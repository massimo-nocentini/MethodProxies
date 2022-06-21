Class {
	#name : #BaselineOfMethodProxies,
	#superclass : #BaselineOf,
	#category : #BaselineOfMethodProxies
}

{ #category : #baselines }
BaselineOfMethodProxies >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			package: #MethodProxies;
			package: #'MethodProxies-Tests'
			with: [ spec requires: #( #MethodProxies ) ];
			package: #MethodProxiesExamples
			with: [ spec requires: #( #MethodProxies ) ];
			package: #'MethodProxiesExamples-Tests'
			with: [ spec requires: #( #MethodProxiesExamples ) ];
			package: #'MethodProxies-Contexts'
			with: [ spec requires: #( #MethodProxies #MethodProxiesExamples ) ];
			package: #'MethodProxies-Contexts-Tests' with: [ 
				spec requires:
						#( #'MethodProxies-Contexts' #'MethodProxiesExamples-Tests' ) ].

		spec
			group: 'Core' with: #( #MethodProxies );
			group: 'All'
			with:
				#( #MethodProxies #'MethodProxies-Tests' #MethodProxiesExamples
				   #'MethodProxiesExamples-Tests' #'MethodProxies-Contexts'
				   #'MethodProxies-Contexts-Tests' ) ]
]
