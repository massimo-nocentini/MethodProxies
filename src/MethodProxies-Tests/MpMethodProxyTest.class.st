Class {
	#name : #MpMethodProxyTest,
	#superclass : #TestCase,
	#instVars : [
		'trackedWrappers'
	],
	#category : #'MethodProxies-Tests'
}

{ #category : #asserting }
MpMethodProxyTest class >> shouldInheritSelectors [
	^ true
]

{ #category : #'tests - safety' }
MpMethodProxyTest >> assertCannotInstall: mp [

	[mp install.
	self fail.]
		on: MpCannotInstall do: [ :ex |
			self assert: ex methodProxy equals: mp ]
]

{ #category : #'tests - safety' }
MpMethodProxyTest >> callEnsureWithNonLocalReturn [
	
	[ ^ 7 ] ensure: [ 2 ]
]

{ #category : #hook }
MpMethodProxyTest >> handlerClass [ 
	^ MpHandler
]

{ #category : #'tests - dead representation' }
MpMethodProxyTest >> installMethodProxy: aMethodProxy [

	trackedWrappers add: aMethodProxy.
	aMethodProxy install.

]

{ #category : #hook }
MpMethodProxyTest >> proxyClass [

	^ MpMethodProxy
]

{ #category : #initialization }
MpMethodProxyTest >> setUp [ 

	super setUp.
	trackedWrappers := OrderedCollection new.
	MpClassA methods do: [ :each | each uninstall ]
	
]

{ #category : #initialization }
MpMethodProxyTest >> tearDown [

	trackedWrappers do: [ :e | e uninstall ].
	super tearDown
]

{ #category : #'tests - installation' }
MpMethodProxyTest >> testCannotProxyUnexistentMethod [

	| mp |
	mp := self proxyClass
		      on: #methodOne
		      inClass: Object
		      handler: self handlerClass new.

	self assertCannotInstall: mp
]

{ #category : #'tests - safety' }
MpMethodProxyTest >> testCannotWrapCriticalProxyMethods [

	| mp handler |
	mp := self proxyClass
		      onMethod: MpMethodProxy >> #valueWithReceiver:arguments:
		      handler: (handler := self handlerClass new).

	self assertCannotInstall: mp
]

{ #category : #'tests - safety' }
MpMethodProxyTest >> testCannotWrapCriticalProxyMethods2 [

	| mp handler |
	mp := self proxyClass
		      onMethod: MpMethodProxy >> #receiver:withArgs:executeMethod:
		      handler: (handler := self handlerClass new).

	self assertCannotInstall: mp
]

{ #category : #'tests - safety' }
MpMethodProxyTest >> testCannotWrapCriticalProxyMethods3 [

	| mp handler |
	mp := self proxyClass
		      onMethod: MpMethodProxy >> #run:with:in:
		      handler: (handler := self handlerClass new).

	self assertCannotInstall: mp
]

{ #category : #'tests - safety' }
MpMethodProxyTest >> testCannotWrapCriticalProxyMethods4 [

	| mp handler |
	mp := self proxyClass
		      onMethod: BlockClosure >> #methodProxyEnsure:
		      handler: (handler := self handlerClass new).

	self assertCannotInstall: mp
]

{ #category : #'tests - safety' }
MpMethodProxyTest >> testCannotWrapCriticalProxyMethods5 [

	| mp handler |
	mp := self proxyClass
		      onMethod: MpMethodProxyActivator >> #value
		      handler: (handler := self handlerClass new).

	self assertCannotInstall: mp
]

{ #category : #'tests - safety' }
MpMethodProxyTest >> testCannotWrapCriticalProxyMethods6 [

	| mp handler |
	mp := self proxyClass
		      onMethod: MpMethodProxyDeactivator >> #value
		      handler: (handler := self handlerClass new).

	self assertCannotInstall: mp
]

{ #category : #'tests - safety' }
MpMethodProxyTest >> testCannotWrapCriticalProxyMethods7 [

	| mp handler |
	mp := self proxyClass
		      onMethod: MpMethodProxyPool class >> #protect
		      handler: (handler := self handlerClass new).

	self assertCannotInstall: mp
]

{ #category : #'tests - dead representation' }
MpMethodProxyTest >> testCreatingAnInstanceDoesNotInstallIt [

	| mp method |
	method := MpClassA >> #methodOne.
	mp := self proxyClass
		      on: #methodOne
		      inClass: MpClassA
		      handler: self handlerClass new.
	self assert: mp selector equals: #methodOne.
	self assert: mp methodClass equals: MpClassA.

	self assert: mp wrappedMethod equals: nil
]

{ #category : #'tests - installation' }
MpMethodProxyTest >> testInstallSetCompiledMethod [

	| mw method |
	[ 
	method := MpClassA >> #methodOne.
	mw := self proxyClass
		      on: #methodOne
		      inClass: MpClassA
		      handler: self handlerClass new.
	mw install.
	self assert: mw selector equals: #methodOne.
	self assert: mw methodClass equals: MpClassA.
	self assert: mw wrappedMethod equals: method ] ensure: [ 
		mw uninstall ]
]

{ #category : #'tests - installation' }
MpMethodProxyTest >> testIsInstalled [

	| mw method |
	[ 
	method := MpClassA >> #methodOne.
	mw := self proxyClass
		      on: #methodOne
		      inClass: MpClassA
		      handler: self handlerClass new.
	self deny: mw isInstalled.
	mw install.
	self assert: mw isInstalled ] ensure: [ mw uninstall ]
]

{ #category : #'tests - installation' }
MpMethodProxyTest >> testUninstall [

	| mp method |
	method := MpClassA >> #methodOne.
	mp := self proxyClass
		      on: #methodOne
		      inClass: MpClassA
		      handler: self handlerClass new.
	mp install.
	self assert: (MpClassA compiledMethodAt: #methodOne) isMethodProxy.
	self assert: (MpClassA compiledMethodAt: #methodOne) == mp.
	mp uninstall.
	self assert: (MpClassA compiledMethodAt: #methodOne) == method.
	self assert: mp wrappedMethod isNil
]

{ #category : #tests }
MpMethodProxyTest >> testUnwrappedMethodAtOneLevelIsTheWrappedMethod [

	| mp method |
	[ 
	method := MpClassA >> #methodOne.
	mp := self proxyClass
		      on: #methodOne
		      inClass: MpClassA
		      handler: self handlerClass new.
	mp install.
	self assert: mp unproxifiedMethod equals: method ] ensure: [ 
		mp uninstall ]
]
