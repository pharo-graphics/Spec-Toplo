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

{ #category : #'class initialization' }
SpToploOverlayAdapter class >> initialize [

	"Define the conversion from Morphic overlay alignments, that are horizontal and vertical
	to Toplo anchored placements, that have both axis mixed.

	In other words, each dictionary association follows this pattern:
	
	{ Morphic Horizontal. Morphic Vertical } -> Toplo placement.
	"
	PlacementConverter := {
		{ SpLayoutWidgetAlignment center. SpLayoutWidgetAlignment center } -> ToAnchoredAtCenter new.
		{ SpLayoutWidgetAlignment center. SpLayoutWidgetAlignment start } -> ToAnchoredAtTop new.
		{ SpLayoutWidgetAlignment center. SpLayoutWidgetAlignment end } -> ToAnchoredAtBottom new.
	
		{ SpLayoutWidgetAlignment start. SpLayoutWidgetAlignment start } -> ToAnchoredAtTopLeft new.
		{ SpLayoutWidgetAlignment start. SpLayoutWidgetAlignment center } -> ToAnchoredAtLeft new.
		{ SpLayoutWidgetAlignment start. SpLayoutWidgetAlignment end } -> ToAnchoredAtBottomLeft new.
	
		{ SpLayoutWidgetAlignment end. SpLayoutWidgetAlignment start } -> ToAnchoredAtTopRight new.
		{ SpLayoutWidgetAlignment end. SpLayoutWidgetAlignment center } -> ToAnchoredAtRight new.
		{ SpLayoutWidgetAlignment end. SpLayoutWidgetAlignment end } -> ToAnchoredAtBottomRight new.
	
		} asDictionary
]

{ #category : #adding }
SpToploOverlayAdapter >> addChildElement: aBlElement with: aSpOverlayConstraints [ 
	"This layout supports a single child and multiple overlays."

	aSpOverlayConstraints isOverlay
		ifTrue: [ aBlElement attachToElement: widget ]
		ifFalse: [ widget addChild: aBlElement as: #singleChild ]
]

{ #category : #adding }
SpToploOverlayAdapter >> addConstraints: aSpOverlayConstraints toChild: aToElement [

	aSpOverlayConstraints isOverlay ifFalse: [ ^ aToElement ].

	self flag: #todo. "See: https://github.com/pharo-graphics/Spec-Toplo/issues/37"
	aToElement fitContent.

	^ aToElement asFloatElement
		offset: 0@0;
		placement: 
			(PlacementConverter at: {
				aSpOverlayConstraints hAlign ifNil: [ SpLayoutWidgetAlignment center ].
				aSpOverlayConstraints vAlign ifNil: [ SpLayoutWidgetAlignment center ] });
		yourself
]

{ #category : #accessing }
SpToploOverlayAdapter >> children [

	^ widget children
]

{ #category : #'instance creation' }
SpToploOverlayAdapter >> newChildBlElement: aPresenter constrainedBy: aSpOverlayConstraints [
	"Inspired on SpMorphicOverlayAdapter>>#basicAdd:constraints:to:"

	^ self
		  newBlElementFrom: aPresenter
		  constraints: aSpOverlayConstraints
]

{ #category : #'instance creation' }
SpToploOverlayAdapter >> newToploWidget [
	"Answer the element where the overlays and the single child will be added."

	^ ToPane horizontal
		matchParent;
		yourself
]
