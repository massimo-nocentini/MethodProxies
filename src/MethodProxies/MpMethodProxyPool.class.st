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

	<methodProxyCannotWrap>
	Activator := [ IsActiveInExecutionStack := true ].
	Deactivator := [ IsActiveInExecutionStack := false ]
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
