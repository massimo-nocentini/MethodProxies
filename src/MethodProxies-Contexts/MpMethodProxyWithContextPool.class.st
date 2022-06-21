"
I am a variant that tries to optimize the allocation of both activator and deactivator blocks.
"
Class {
	#name : #MpMethodProxyWithContextPool,
	#superclass : #MpMethodProxyPool,
	#classVars : [
		'Activator',
		'Deactivator'
	],
	#category : #'MethodProxies-Contexts'
}

{ #category : #initialization }
MpMethodProxyWithContextPool class >> initialize [

	<methodProxyCannotWrap>
	Activator := [ IsActiveInExecutionStack := true ].
	Deactivator := [ IsActiveInExecutionStack := false ]
]
