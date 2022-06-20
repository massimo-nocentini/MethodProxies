"
I am a variant that reifies contexts in `MpMethodProxyWithContext>>#run:with:in:` and pass them around to handlers.
"
Class {
	#name : #MpMethodProxyWithContext,
	#superclass : #MpMethodProxy,
	#classVars : [
		'Activator',
		'Deactivator'
	],
	#category : #MethodProxies
}

{ #category : #initialization }
MpMethodProxyWithContext class >> initialize [

	Activator := MpMethodProxyActivator new.
	Deactivator := MpMethodProxyDeactivator new
]

{ #category : #accessing }
MpMethodProxyWithContext >> handler: aHandler [

	handler := aHandler
]

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

	"Reify the current context."
	ctx := thisContext.

	"We are now in the instrumentation world.
	Do not instrument the instrumentation."
	IsActiveInExecutionStack := true.

	"Purposely do not use a non-local return.
	Otherwise the non-local return logic would be instrumented once the ensure block is executed.
	However, since a lot of code executes between the ensure block and the real method return, this could end in infinite loops"
	[ 
	returnValue := self
		               valueOf: aSelector
		               inReceiver: aReceiver
		               arguments: anArrayOfObjects
		               context: ctx ] ensure: [ Deactivator value ].

	^ returnValue
]

{ #category : #'as yet unclassified' }
MpMethodProxyWithContext >> valueOf: aSelector inReceiver: aReceiver arguments: arguments context: aContext [

	<methodProxyCannotWrap>
	| result carry |
	"Hooking into user methods to define before actions.
	Before actions are not instrumented."
	carry := handler
		         beforeExecutionOf: aSelector
		         inReceiver: aReceiver
		         arguments: arguments
		         context: aContext.

	"Purposely do not use a non-local return.
	Otherwise the non-local return logic would be instrumented and this could end in infinite loops"
	[ 
	IsActiveInExecutionStack := false.
	result := self
		          receiver: aReceiver
		          withArgs: arguments
		          executeMethod: proxifiedMethod.

	"Eagerly set it to true to avoid instrumenting all messages done during the ensure"
	IsActiveInExecutionStack := true ] methodProxyEnsure: [ 
		Activator value ].

	"Hooking into user methods to define after actions.
	After actions are not instrumented."
	^ handler
		  afterExecutionOf: aSelector
		  inReceiver: aReceiver
		  arguments: arguments
		  returnValue: result
		  carry: carry
		  context: aContext
]
