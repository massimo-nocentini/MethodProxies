"
I am a variant that overrides the *after* hook such that the returned value 
is converted as `String` and some debugging test is appended to it.
"
Class {
	#name : #MpMockMethodProxyHandler,
	#superclass : #MpHandler,
	#category : #'MethodProxiesExamples-Tests'
}

{ #category : #evaluating }
MpMockMethodProxyHandler >> afterExecutionWithReceiver: receiver arguments: arguments returnValue: returnValue [

	^ 'trapped [', returnValue asString, ']'
]
