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

			spec
				package: 'Spec-Toplo' with: [ spec requires: #('Toplo') ];
				package: 'Spec-Toplo-Tests' with: [ spec requires: #('Spec-Toplo') ];
				package: 'Spec-Toplo-Examples-ToDoList'
		]
]

{ #category : #'external projects' }
BaselineOfSpecToplo >> declareToploOn: spec [

	spec
		baseline: 'Toplo'
		with: [ spec repository: 'github://pharo-graphics/Toplo:dev/src' ]
]
