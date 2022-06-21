Class {
	#name : #MpFailingMethodProxyTest,
	#superclass : #MpMethodProxyTest,
	#category : #'MethodProxiesExamples-Tests'
}

{ #category : #'tests - safety' }
MpFailingMethodProxyTest >> handlerClass [

	^ MpFailingHandlerMock
]

{ #category : #'tests - safety' }
MpFailingMethodProxyTest >> testExceptionsDuringInstrumentationDoNotBreakInstrumentation [

	"Managing exceptions in the wrapper"

	| w |
	w := self proxyClass
		     onMethod: MpClassB >> #methodTwo
		     handler: self handlerClass new.

	self installMethodProxy: w.

	"An error during instrumentation should not break the instrumentation.
	Subsequent calls should still be instrumented"
	2 timesRepeat: [ 
		[ 
		MpClassB new methodTwo.
		self fail ]
			on: Error
			do: [ :error | 
				self
					assert: error messageText
					equals: 'error during instrumentation' ] ]
]
