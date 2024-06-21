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
SpToploDirectionableLayoutAdapter >> newToploWidget [
	"Answer the new Toplo widget."

	^ layout direction newWidgetOn: self
]

{ #category : #'instance creation' }
SpToploDirectionableLayoutAdapter >> newVerticalPane [

	^ ToPane vertical
]
