"
I am a trait that defines both the pre and post handler hooks that take care of contexts reified by `MpMethodProxyWithContext`.
"
Trait {
	#name : #TMpHandlerWithContext,
	#category : #'MethodProxies-Contexts'
}

{ #category : #hooks }
TMpHandlerWithContext >> afterExecutionOf: aSelector inReceiver: anObject arguments: anArrayOfObjects returnValue: aReturnValue carry: carry context: aContext [

	^ self
		  afterExecutionWithReceiver: anObject
		  arguments: anArrayOfObjects
		  returnValue: aReturnValue
]

{ #category : #hooks }
TMpHandlerWithContext >> beforeExecutionOf: aSelector inReceiver: receiver arguments: arguments context: aContext [

	^ self beforeExecutionWithReceiver: receiver arguments: arguments
]
