Class {
	#name : #MpCountingMethodProxyTest,
	#superclass : #MpMethodProxyTest,
	#category : #'MethodProxiesExamples-Tests'
}

{ #category : #tests }
MpCountingMethodProxyTest >> handlerClass [

	^ MpCountingHandler
]

{ #category : #tests }
MpCountingMethodProxyTest >> testCounts [

	| proxy instance handler |
	[ proxy := MpMethodProxy
		on: #methodOne
		inClass: MpClassA
		handler: (handler := self handlerClass new).
	proxy install.
	instance := MpClassA new.
	self assert: handler count equals: 0.
	instance methodOne.
	self assert: handler count equals: 1.
	instance methodOne.
	self assert: handler count equals: 2 ] ensure: [ proxy uninstall ]
]

{ #category : #tests }
MpCountingMethodProxyTest >> testInversions [

	"Dual of `MTVisualizationsTest>>#testInspectInversions`"

	| proxies |
	proxies := OrderedCollection new.

	[ "Setting up."
	proxies add: (MpMethodProxy
			 on: #inversions:
			 inClass: SequenceableCollection
			 handler: self handlerClass new).

	proxies add: (MpMethodProxy
			 on: #merge:sortBlock:on:inversionsOrNil:
			 inClass: PositionableStream
			 handler: self handlerClass new).

	proxies add: (MpMethodProxy
			 on: #bisect:baseBlock:
			 inClass: SequenceableCollection
			 handler: self handlerClass new).

	proxies add: (MpMethodProxy
			 on: #bisect:from:to:baseBlock:
			 inClass: SequenceableCollection
			 handler: self handlerClass new).

	proxies add: (MpMethodProxy
			 on: #nextPut:inversion:
			 inClass: Stream
			 handler: self handlerClass new).

	"Install."
	proxies do: [ :each | each install ].

	"Do."
	{ 2. 4. 1. 3. 5 } inversions: [ :i :j | i < j ].

	"Check."
	self assert: proxies first handler count equals: 1.
	self assert: proxies second handler count equals: 4.
	self assert: proxies third handler count equals: 1.
	self assert: proxies fourth handler count equals: 9.
	self assert: proxies fifth handler count equals: 3 ] ensure: [ 
		proxies do: [ :each | each uninstall ] ]
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
		           MpMethodProxy
			           on: each selector
			           inClass: each methodClass
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
		           MpMethodProxy
			           on: each selector
			           inClass: each methodClass
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
