Class {
	#name : #MpHandlerWithContext,
	#superclass : #MpHandler,
	#category : #MethodProxies
}

{ #category : #'as yet unclassified' }
MpHandlerWithContext >> afterExecutionOf: aSelector inReceiver: anObject arguments: anArrayOfObjects returnValue: aReturnValue carry: carry context: aContext [

	^ self
		  afterExecutionWithReceiver: anObject
		  arguments: anArrayOfObjects
		  returnValue: aReturnValue
]

{ #category : #'as yet unclassified' }
MpHandlerWithContext >> beforeExecutionOf: aSelector inReceiver: receiver arguments: arguments context: aContext [

	^ self beforeExecutionWithReceiver: receiver arguments: arguments
]
