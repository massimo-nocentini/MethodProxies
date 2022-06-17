Trait {
	#name : #TMpHandlerWithContext,
	#category : #MethodProxies
}

{ #category : #'as yet unclassified' }
TMpHandlerWithContext >> afterExecutionWithReceiver: anObject arguments: anArrayOfObjects returnValue: aReturnValue carry: carry context: aContext [

	self afterMethod.

	^ aReturnValue
]

{ #category : #'as yet unclassified' }
TMpHandlerWithContext >> beforeExecutionWithReceiver: receiver arguments: arguments context: aContext [

	self beforeMethod
]
