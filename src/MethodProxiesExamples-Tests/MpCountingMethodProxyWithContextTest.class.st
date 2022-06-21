Class {
	#name : #MpCountingMethodProxyWithContextTest,
	#superclass : #MpCountingMethodProxyTest,
	#category : #'MethodProxiesExamples-Tests'
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

	(Array with: bench with: benchWithContext) inspect
]

{ #category : #hook }
MpCountingMethodProxyWithContextTest >> proxyClass [

	^ MpMethodProxyWithContext
]
