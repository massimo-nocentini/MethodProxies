Class {
	#name : #MpHandlerWithContext,
	#superclass : #MpHandler,
	#category : #MethodProxies
}

{ #category : #'as yet unclassified' }
MpHandlerWithContext >> afterExecutionWithReceiver: anObject arguments: anArrayOfObjects returnValue: aReturnValue carry: carry context: aContext [

	^ self
		  afterExecutionWithReceiver: anObject
		  arguments: anArrayOfObjects
		  returnValue: aReturnValue
]

{ #category : #'as yet unclassified' }
MpHandlerWithContext >> beforeExecutionWithReceiver: receiver arguments: arguments context: aContext [

	^ self beforeExecutionWithReceiver: receiver arguments: arguments
]
