Class {
	#name : #MpCountingMethodProxyWithContextTest,
	#superclass : #MpCountingMethodProxyTest,
	#category : #'MethodProxies-Contexts-Tests'
}

{ #category : #benchmarking }
MpCountingMethodProxyWithContextTest >> benchOpalCompiler [

	<script: 'self new benchOpalCompiler'>
	| proxies bench benchWithContext |
	"Setting up."
	proxies := ({ #'AST-Core' asPackage } flatCollect: [ :each | 
		            each methods ]) collect: [ :each | 
		           super proxyClass
			           onMethod: each
			           handler: self handlerClass new ].

	[ "Install."
	proxies do: [ :each | each install ].

	"Do."
	bench := [ OpalCompiler recompile ] bench ] ensure: [ 
		proxies do: [ :each | each uninstall ] ].

	"Setting up."
	proxies := ({ #'AST-Core' asPackage } flatCollect: [ :each | 
		            each methods ]) collect: [ :each | 
		           self proxyClass
			           onMethod: each
			           handler: self handlerClass new ].

	[ "Install."
	proxies do: [ :each | each install ].

	"Do."
	benchWithContext := [ OpalCompiler recompile ] bench ] ensure: [ 
		proxies do: [ :each | each uninstall ] ].

	Dictionary new
		at: 'without contexts' put: bench;
		at: 'with contexts' put: benchWithContext;
		inspect
]

{ #category : #hook }
MpCountingMethodProxyWithContextTest >> handlerClass [

	^ MpCountingWithContextHandler
]

{ #category : #'tests - safety' }
MpCountingMethodProxyWithContextTest >> mockHandlerClass [

	^ MpMockWithContextHandler
]

{ #category : #hook }
MpCountingMethodProxyWithContextTest >> proxyClass [

	^ MpMethodProxyWithContext
]

{ #category : #tests }
MpCountingMethodProxyWithContextTest >> testCanWrapValueWithException [

	| mp handler |
	mp := self proxyClass
		      onMethod: (FullBlockClosure lookupSelector: #value)
		      handler: (handler := self handlerClass new).

	self installMethodProxy: mp.

	[ [ [ 1 error ] value ] value ]
		on: Error
		do: #yourself. "to avoid an extra block"

	self assert: handler count equals: 8 + 1 "value" "on:do:"
]

{ #category : #tests }
MpCountingMethodProxyWithContextTest >> testCannotWrapCriticalProxyMethods8 [

	| mp handler |
	mp := self proxyClass
		      onMethod: MpMethodProxyWithContextPool class >> #initialize
		      handler: (handler := self handlerClass new).

	self assertCannotInstall: mp
]
