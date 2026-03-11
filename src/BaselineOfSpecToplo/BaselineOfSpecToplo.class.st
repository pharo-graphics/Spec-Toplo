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
			self declareRoassalBlocGroupOn: spec.

			spec
				package: 'Spec-Toplo' with: [ spec requires: #('Toplo') ];
				package: 'Spec-Toplo-Tests' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Examples' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Examples-ToDoList' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Examples-Chooser' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Examples-Diff' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Examples-Tree' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Roassal' with: [ spec requires: #('Spec-Toplo' 'Roassal') ]
		]
]

{ #category : #'external projects' }
BaselineOfSpecToplo >> declareRoassalBlocGroupOn: spec [

	| branch |
	SystemVersion current major = 13
		ifTrue: [ branch := 'Pharo13' ]
		ifFalse: [
			SystemVersion current major = 14
				ifTrue: [ branch := 'Pharo14' ]
				ifFalse: [ self notYetImplemented ] ].

	spec
		package: 'Roassal-Bloc'
		with: [ spec repository: 'github://pharo-graphics/Roassal:', branch, '/src' ]
]

{ #category : #'external projects' }
BaselineOfSpecToplo >> declareToploOn: spec [

	spec
		baseline: 'Toplo'
		with: [ spec repository: 'github://pharo-graphics/Toplo:master/src' ]
]
