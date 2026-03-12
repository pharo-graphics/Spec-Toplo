Class {
	#name : #BaselineOfSpecToplo,
	#superclass : #BaselineOf,
	#category : #BaselineOfSpecToplo
}

{ #category : #baselines }
BaselineOfSpecToplo >> baseline: spec [
	<baseline>
	
	spec
		for: #common
		do: [ 
			self declareToploOn: spec.
			self declareRoassalBlocPackageOn: spec.

			spec
				package: 'Spec-Toplo' with: [ spec requires: #('Toplo') ];
				package: 'Spec-Toplo-Tests' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Examples' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Examples-ToDoList' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Examples-Chooser' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Examples-Diff' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Examples-Tree' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Roassal' with: [ spec requires: #('Spec-Toplo' 'Roassal-Bloc') ]
		]
]

{ #category : #'external projects' }
BaselineOfSpecToplo >> declareRoassalBlocPackageOn: spec [

	| branch |
	SystemVersion current major = 13
		ifTrue: [ branch := 'v1.7.5' ]
		ifFalse: [
			SystemVersion current major = 14
				ifTrue: [ branch := 'e0e475d1da8cd2bb31d8ee3759ef0d774d693c00' ]
				ifFalse: [ self notYetImplemented ] ].

	spec
		package: 'Roassal-Bloc'
		with: [ spec repository: 'github://pharo-graphics/Roassal:', branch, '/src' ]
]

{ #category : #'external projects' }
BaselineOfSpecToplo >> declareToploOn: spec [

	spec
		baseline: 'Toplo'
		with: [ spec repository: 'github://pharo-graphics/Toplo:v0.9.0/src' ]
]
