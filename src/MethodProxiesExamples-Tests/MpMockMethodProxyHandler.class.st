Class {
	#name : #MpMockMethodProxyHandler,
	#superclass : #MpHandler,
	#category : #'MethodProxiesExamples-Tests'
}

{ #category : #evaluating }
MpMockMethodProxyHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	^ 'trapped [', returnValue asString, ']'
]
