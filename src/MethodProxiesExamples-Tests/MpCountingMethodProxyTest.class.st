Class {
	#name : #MpCountingMethodProxyTest,
	#superclass : #MpMethodProxyTest,
	#category : #'MethodProxiesExamples-Tests'
}

{ #category : #tests }
MpCountingMethodProxyTest >> handlerClass [

	^ MpCountingHandler
]

{ #category : #'tests - safety' }
MpCountingMethodProxyTest >> mockHandlerClass [

	^ MpMockMethodProxyHandler
]

{ #category : #'tests - safety' }
MpCountingMethodProxyTest >> testCanWrapAboutToReturnThroughWithNonLocalReturn [

	| mp handler |
	mp := self proxyClass
		      onMethod: Context >> #aboutToReturn:through:
		      handler: (handler := self handlerClass new).

	self installMethodProxy: mp.

	self callEnsureWithNonLocalReturn.

	self assert: handler count equals: 1
]

{ #category : #'tests - safety' }
MpCountingMethodProxyTest >> testCanWrapEnsure [

	| mp handler |
	mp := self proxyClass
		      onMethod: BlockClosure >> #ensure:
		      handler: (handler := self handlerClass new).

	self installMethodProxy: mp.

	[ 1 ] ensure: [ 2 ].

	self assert: handler count equals: 1
]

{ #category : #'tests - safety' }
MpCountingMethodProxyTest >> testCanWrapEnsureNonLocalReturn [

	| mp handler |
	mp := self proxyClass
		      onMethod: BlockClosure >> #ensure:
		      handler: (handler := self handlerClass new).

	self installMethodProxy: mp.

	self callEnsureWithNonLocalReturn.

	self assert: handler count equals: 1
]

{ #category : #'tests - safety' }
MpCountingMethodProxyTest >> testCanWrapEnsureWithException [

	| mp handler |
	mp := self proxyClass
		      onMethod: BlockClosure >> #ensure:
		      handler: (handler := self handlerClass new).

	self installMethodProxy: mp.

	[ [ 1 error ] ensure: [ 2 ] ]
		on: Error
		do: [ "nothing" ].

	self assert: handler count equals: 1
]

{ #category : #'tests - safety' }
MpCountingMethodProxyTest >> testCanWrapValue [

	| mp handler |
	mp := self proxyClass
		      onMethod: (FullBlockClosure lookupSelector: #value)
		      handler: (handler := self handlerClass new).

	self installMethodProxy: mp.

	[ [ 1 ] value ] value.

	self assert: handler count equals: 2
]

{ #category : #'tests - safety' }
MpCountingMethodProxyTest >> testCanWrapValueWithException [

	| mp handler |
	mp := self proxyClass
		      onMethod: (FullBlockClosure lookupSelector: #value)
		      handler: (handler := self handlerClass new).

	self installMethodProxy: mp.

	[ [ [ 1 error ] value ] value ]
		on: Error
		do: #yourself. "to avoid an extra block"

	self assert: handler count equals: 2 + 1 "value" "on:do:"
]

{ #category : #tests }
MpCountingMethodProxyTest >> testCounts [

	| proxy instance handler |
	[ 
	proxy := self proxyClass
		         onMethod: MpClassA >> #methodOne
		         handler: (handler := self handlerClass new).
	proxy install.
	instance := MpClassA new.
	self assert: handler count equals: 0.
	instance methodOne.
	self assert: handler count equals: 1.
	instance methodOne.
	self assert: handler count equals: 2 ] ensure: [ proxy uninstall ]
]

{ #category : #'tests - safety' }
MpCountingMethodProxyTest >> testExceptionsAfterInstrumentationDoNotBreakInstrumentation [

	| mp handler |
	mp := self proxyClass
		      onMethod: Object >> #error:
		      handler: (handler := self handlerClass new).

	self installMethodProxy: mp.

	"An error after instrumentation should not break the instrumentation.
	Subsequent calls should still be instrumented, and the counting code should still execute regardless the exception"
	2 timesRepeat: [ 
		[ 
		MpClassB new error: 'error after instrumentation'.
		self fail ]
			on: Error
			do: [ :error |  ] ].

	self assert: handler count equals: 2
]

{ #category : #'tests - safety' }
MpCountingMethodProxyTest >> testExceptionsAfterInstrumentationFlow [

	"Managing exceptions in the wrapper"

	| p |
	p := self proxyClass
		     onMethod: Object >> #error:
		     handler: self handlerClass new.

	self installMethodProxy: p.

	"An error after instrumentation should not break the instrumentation.
	Subsequent calls should still be instrumented"
	2 timesRepeat: [ 
		[ 
		MpClassB new error: 'error after instrumentation'.
		self fail ]
			on: Error
			do: [ :error | 
				self
					assert: error messageText
					equals: 'error after instrumentation' ] ]
]

{ #category : #tests }
MpCountingMethodProxyTest >> testMergesort [

	"Dual of `MTVisualizationsTest>>#testSequenceableCollectionMergeSortCopying`"

	| proxies anArray |
	anArray := #( 19 9 14 15 3 16 11 4 5 12 13 7 10 2 6 17 20 18 8 1 )
		           copy.
	"Setting up."
	proxies := { 
		           (SequenceableCollection >> #sort).
		           (SequenceableCollection >> #mergeSortFrom:to:by:).
		           (SequenceableCollection
		            >> #mergeFirst:middle:last:into:by:).
		           (SequenceableCollection >> #mergeSortFrom:to:src:dst:by:).
		           (Array >> #replaceFrom:to:with:startingAt:) } collect: [ 
		           :each | 
		           self proxyClass
			           onMethod: each
			           handler: self handlerClass new ].

	[ "Install."
	proxies do: [ :each | each install ].

	"Do."
	anArray sort.

	"Check."
	self assert: proxies first handler count equals: 1.
	self assert: proxies second handler count equals: 1.
	self assert: proxies third handler count equals: 19.
	self assert: proxies fourth handler count equals: 39.
	self assert: proxies fifth handler count equals: 19 ] ensure: [ 
		proxies do: [ :each | each uninstall ] ]
]

{ #category : #tests }
MpCountingMethodProxyTest >> testOpalCompiler [

	"Dual of `MTHandlerTest>>#exampleOpalCompiler`"

	| proxies timeToRun |
	"Setting up."
	proxies := ({ #'AST-Core' asPackage } flatCollect: [ :each | 
		            each methods ]) collect: [ :each | 
		           self proxyClass
			           onMethod: each
			           handler: self handlerClass new ].

	[ "Install."
	proxies do: [ :each | each install ].

	"Do."
	timeToRun := [ OpalCompiler recompile ] timeToRun ] ensure: [ 
		proxies do: [ :each | each uninstall ] ].

	(proxies sorted: [ :aProxy :anotherProxy | 
		 aProxy handler count > anotherProxy handler count ]) inspect.

	timeToRun inspect
]

{ #category : #'tests - safety' }
MpCountingMethodProxyTest >> testRecursiveMethodWrapperDoesNotRecurse1 [

	| mw method mw1 |
	method := MpMockObject >> #recursiveMethod.
	mw := self proxyClass
		      onMethod: method
		      handler: self mockHandlerClass new.
	self installMethodProxy: mw.

	method := ByteString lookupSelector: #,.
	mw1 := self proxyClass
		       onMethod: method
		       handler: self handlerClass new.
	self installMethodProxy: mw1.

	self
		assert: MpMockObject new recursiveMethod
		equals: 'trapped [original]'.

	self assert: mw1 handler count equals: 0
]
