Class {
	#name : #MpMockMethodProxyTest,
	#superclass : #MpMethodProxyTest,
	#category : #'MethodProxiesExamples-Tests'
}

{ #category : #'tests - installation' }
MpMockMethodProxyTest >> handlerClass [

	^ MpMockMethodProxyHandler
]

{ #category : #'tests - installation' }
MpMockMethodProxyTest >> testIsInstalledNestedMWAreNotInstalled [

	| mp method mp2 |
	method := MpClassA >> #methodOne.
	mp := self proxyClass
		      on: #methodOne
		      inClass: MpClassA
		      handler: super handlerClass new.
	mp2 := self proxyClass
		       on: #methodOne
		       inClass: MpClassA
		       handler: self handlerClass new.
	mp install.
	mp2 install.
	self deny: mp isInstalled.
	self assert: mp2 isInstalled.
	mp2 uninstall.
	self deny: mp2 isInstalled.
	self assert: mp isInstalled.
	mp uninstall.
	self deny: mp isInstalled
]

{ #category : #'tests - safety' }
MpMockMethodProxyTest >> testRecursiveMethodWrapperDoesNotRecurse [

	| mw method |
	method := MpMockObject >> #recursiveMethod.
	mw := self proxyClass onMethod: method handler: self handlerClass new.
	self installMethodProxy: mw.

	self
		assert: MpMockObject new recursiveMethod
		equals: 'trapped [original]'
]

{ #category : #'tests - installation' }
MpMockMethodProxyTest >> testUninstallNestedInRightOrderIsOk [

	| mp mp2 method |
	method := MpClassA >> #methodOne.
	mp := self proxyClass
		      on: #methodOne
		      inClass: MpClassA
		      handler: super handlerClass new.
	mp2 := self proxyClass
		       on: #methodOne
		       inClass: MpClassA
		       handler: self handlerClass new.
	mp install.
	mp2 install.
	self assert: (MpClassA compiledMethodAt: #methodOne) isMethodProxy.
	self assert: (MpClassA compiledMethodAt: #methodOne) identicalTo: mp2.
	mp2 uninstall.
	self assert: (MpClassA compiledMethodAt: #methodOne) identicalTo: mp.
	mp uninstall.
	self
		assert: (MpClassA compiledMethodAt: #methodOne)
		identicalTo: method
]

{ #category : #tests }
MpMockMethodProxyTest >> testUnwrappedMethodOfNestedMethodWrapperInTheCompiledMethod [

	| mp method mp2 |
	[ 
	method := MpClassA >> #methodOne.
	mp := self proxyClass
		      on: #methodOne
		      inClass: MpClassA
		      handler: super handlerClass new.
	mp install.
	mp2 := self proxyClass
		       on: #methodOne
		       inClass: MpClassA
		       handler: self handlerClass new.
	mp2 install.

	self assert: mp2 wrappedMethod equals: mp.
	self assert: mp2 unproxifiedMethod equals: method ] ensure: [ 
		mp2 uninstall.
		mp uninstall ]
]

{ #category : #tests }
MpMockMethodProxyTest >> testWrappingTwiceIsPossible [

	| mp1 method mp2 |
	[ 
	method := MpClassA >> #methodOne.
	mp1 := self proxyClass
		       on: #methodOne
		       inClass: MpClassA
		       handler: super handlerClass new.
	mp1 install.

	mp2 := self proxyClass
		       on: #methodOne
		       inClass: MpClassA
		       handler: self handlerClass new.
	mp2 install.

	self assert: mp1 selector equals: #methodOne.
	self assert: mp1 methodClass equals: MpClassA.
	self assert: mp1 wrappedMethod equals: method.

	self assert: mp2 selector equals: #methodOne.
	self assert: mp2 methodClass equals: MpClassA.
	self assert: mp2 wrappedMethod equals: mp1 ] ensure: [ 
		mp2 uninstall.
		self assert: (MpClassA methodDict at: #methodOne) equals: mp1.
		mp1 uninstall.
		self assert: (MpClassA methodDict at: #methodOne) equals: method ]
]
