Class {
	#name : #SpToploScrollableAdapter,
	#superclass : #SpToploLayoutAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploScrollableAdapter >> addChildElement: aToElement with: aSpBoxConstraints [

	self widget addChild: aToElement
]

{ #category : #adding }
SpToploScrollableAdapter >> addConstraints: aSpBoxConstraints toChild: childBlElement [ 
	childBlElement matchParent.

	^ childBlElement

]

{ #category : #'instance creation' }
SpToploScrollableAdapter >> newChildBlElement: aPresenter constrainedBy: aSpBoxConstraints [

	^ self newBlElementFrom: aPresenter constraints: aSpBoxConstraints
]

{ #category : #'instance creation' }
SpToploScrollableAdapter >> newToploWidget [

	^ ToScrollableElement new
]
