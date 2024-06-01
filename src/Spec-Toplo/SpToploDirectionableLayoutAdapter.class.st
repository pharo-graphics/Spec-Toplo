Class {
	#name : #SpToploDirectionableLayoutAdapter,
	#superclass : #SpToploLayoutAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'instance creation' }
SpToploDirectionableLayoutAdapter >> newHorizontalPane [

	^ ToPane horizontal
]

{ #category : #'instance creation' }
SpToploDirectionableLayoutAdapter >> newVerticalPane [

	^ ToPane vertical
]
