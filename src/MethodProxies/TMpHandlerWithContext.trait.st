"
I am a trait that defines both the pre and post handler hooks that take care of contexts reified by `MpMethodProxyWithContext`.
"
Trait {
	#name : #TMpHandlerWithContext,
	#category : #MethodProxies
}

{ #category : #hooks }
TMpHandlerWithContext >> afterExecutionOf: aSelector inReceiver: anObject arguments: anArrayOfObjects returnValue: aReturnValue carry: carry context: aContext [

	self explicitRequirement
]

{ #category : #hooks }
TMpHandlerWithContext >> beforeExecutionOf: aSelector inReceiver: receiver arguments: arguments context: aContext [

	self explicitRequirement
]
