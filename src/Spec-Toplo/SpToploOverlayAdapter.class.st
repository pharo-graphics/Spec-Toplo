"
I'm a Spec adapter for `SpOverlayLayout`.
"
Class {
	#name : #SpToploOverlayAdapter,
	#superclass : #SpToploLayoutAdapter,
	#classVars : [
		'PlacementConverter'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploOverlayAdapter >> addChildElement: aToPane with: aSpOverlayConstraints [ 

	aSpOverlayConstraints isOverlay 
		ifTrue: [ widget addChildFirst: aToPane ]
		ifFalse: [ widget addChild: aToPane at: widget childrenCount + 1 ].

]

{ #category : #adding }
SpToploOverlayAdapter >> addConstraints: aSpOverlayConstraints toChild: aBlElement [
	"Inspired on SpMorphicOverlayAdapter>>#addConstraints:toChild:"
	
	^  aBlElement
]

{ #category : #'instance creation' }
SpToploOverlayAdapter >> newChildBlElement: aPresenter constrainedBy: aSpOverlayConstraints [ 
	"Inspired on SpMorphicOverlayAdapter>>#basicAdd:constraints:to:"
	
	| newElement |
	newElement := self newBlElementFrom: aPresenter constraints: aSpOverlayConstraints.
	
	^ newElement
]

{ #category : #'instance creation' }
SpToploOverlayAdapter >> newToploWidget [

	^ ToPane horizontal
		matchParent;
		yourself
]
