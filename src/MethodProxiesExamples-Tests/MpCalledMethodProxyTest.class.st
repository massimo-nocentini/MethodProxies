Class {
	#name : #MpCalledMethodProxyTest,
	#superclass : #MpMethodProxyTest,
	#category : #'MethodProxiesExamples-Tests'
}

{ #category : #hook }
MpCalledMethodProxyTest >> handlerClass [

	^ MpCalledHandler
]

{ #category : #'tests - safety' }
MpCalledMethodProxyTest >> testWrapEssentialPrimitiveShouldBeCalledDuringInstallation [

	| mw method handler |
	method := SmallInteger >> #+.
	mw := self proxyClass
		      onMethod: method
		      handler: (handler := MpCalledHandler new).
	self installMethodProxy: mw.

	self deny: handler called
]

{ #category : #'tests - safety' }
MpCalledMethodProxyTest >> testWrapEssentialPrimitiveShouldNotRecurse [

	| mw method handler |
	method := SmallInteger >> #+.
	mw := self proxyClass
		      onMethod: method
		      handler: (handler := MpCalledHandler new).
	self installMethodProxy: mw.

	"Do a perform, otherwise the addition is optimized out and tried as non-send addition.
	A message send is issued only if the normal addition fails"
	1 perform: #+ with: 2.

	self assert: handler called
]

{ #category : #'tests - safety' }
MpCalledMethodProxyTest >> testWrapMethodCalledDuringInstallationIsNotIntercepted [

	| mw method handler |
	method := SmallInteger lookupSelector: #max:.
	mw := self proxyClass
		      onMethod: method
		      handler: (handler := MpCalledHandler new).
	self installMethodProxy: mw.

	self deny: handler called
]
