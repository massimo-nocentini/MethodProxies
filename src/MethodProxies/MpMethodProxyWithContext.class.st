Class {
	#name : #MpMethodProxyWithContext,
	#superclass : #MpMethodProxy,
	#category : #MethodProxies
}

{ #category : #evaluation }
MpMethodProxyWithContext >> run: aSelector with: anArrayOfObjects in: aReceiver [

	"Do not intercept"

	<methodProxyCannotWrap>
	| returnValue ctx |
	(isDisabled or: [ "Check explicitly that the flag has been set.
		This allows proxies to work independently of initialization side effects." 
		 IsActiveInExecutionStack == true ]) ifTrue: [ 
		^ self
			  receiver: aReceiver
			  withArgs: anArrayOfObjects
			  executeMethod: proxifiedMethod ].

	"We are now in the instrumentation world.
	Do not instrument the instrumentation."
	IsActiveInExecutionStack := true.

	"Reify the current context."
	ctx := thisContext.

	"Purposely do not use a non-local return.
	Otherwise the non-local return logic would be instrumented once the ensure block is executed.
	However, since a lot of code executes between the ensure block and the real method return, this could end in infinite loops"
	[ 
	returnValue := self
		               valueWithReceiver: aReceiver
		               arguments: anArrayOfObjects
		               context: ctx ] ensure: MpMethodProxyDeactivator new.

	^ returnValue
]

{ #category : #'as yet unclassified' }
MpMethodProxyWithContext >> valueWithReceiver: receiver arguments: arguments context: aContext [

	<methodProxyCannotWrap>
	| result |
	"Hooking into user methods to define before actions.
	Before actions are not instrumented."
	handler
		beforeExecutionWithReceiver: receiver
		arguments: arguments
		context: aContext.

	"Purposely do not use a non-local return.
	Otherwise the non-local return logic would be instrumented and this could end in infinite loops"
	[ 
	IsActiveInExecutionStack := false.
	result := self
		          receiver: receiver
		          withArgs: arguments
		          executeMethod: proxifiedMethod.

	"Eagerly set it to true to avoid instrumenting all messages done during the ensure"
	IsActiveInExecutionStack := true ] methodProxyEnsure:
		MpMethodProxyActivator new.

	"Hooking into user methods to define after actions.
	After actions are not instrumented."
	^ handler
		  afterExecutionWithReceiver: receiver
		  arguments: arguments
		  returnValue: result
		  context: aContext
]
