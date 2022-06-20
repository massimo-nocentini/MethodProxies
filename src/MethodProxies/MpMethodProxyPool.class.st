Class {
	#name : #MpMethodProxyPool,
	#superclass : #SharedPool,
	#classVars : [
		'Activator',
		'Deactivator',
		'IsActiveInExecutionStack'
	],
	#category : #MethodProxies
}

{ #category : #initialization }
MpMethodProxyPool class >> initialize [

	| act deact |
	act := MpMethodProxyActivator new.
	deact := MpMethodProxyDeactivator new.

	Activator := [ act value ].
	Deactivator := [ deact value ]
]

{ #category : #activation }
MpMethodProxyPool class >> isProtected [

	^ IsActiveInExecutionStack == true
]

{ #category : #activation }
MpMethodProxyPool class >> protect [
	<methodProxyCannotWrap>
	IsActiveInExecutionStack := true
]

{ #category : #activation }
MpMethodProxyPool class >> unprotect [

	IsActiveInExecutionStack := false
]
