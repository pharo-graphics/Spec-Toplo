"
I'm a Spec adapter for `SpPanedLayout`.
"
Class {
	#name : #SpToploPanedAdapter,
	#superclass : #SpToploDirectionableLayoutAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploPanedAdapter >> addChildElement: aBlElement with: aSpPanedConstraints [

	widget childrenCount = 1
		ifTrue: [
			widget addDividers.

"			aBlElement constraintsDo: [ :c |
				c linear weight: layout positionOfSlider ].
"			
			widget addChild: aBlElement as: #firstPaned  ]
		ifFalse: [ 
"			aBlElement constraintsDo: [ :c |
				c linear weight: (1 - layout positionOfSlider) ]."

			widget addChild: aBlElement as: #secondPaned ]

]

{ #category : #adding }
SpToploPanedAdapter >> addConstraints: aSpPanedConstraints toChild: childBlElement [ 
	"Inspired by SpMorphicPanedAdapter>>#addConstraints:toChild:"

	childBlElement matchParent.

	^ childBlElement

]

{ #category : #accessing }
SpToploPanedAdapter >> children [

	^ widget children
]

{ #category : #'instance creation' }
SpToploPanedAdapter >> newChildBlElement: aPresenter constrainedBy: aSpBoxConstraints [
	"Inspired on SpMorphicPanedAdapter>>#basicAdd:constraints:to:"

	^ self newBlElementFrom: aPresenter constraints: aSpBoxConstraints
]

{ #category : #'instance creation' }
SpToploPanedAdapter >> newHorizontal [

	^ self newHorizontalPane
]

{ #category : #'instance creation' }
SpToploPanedAdapter >> newVertical [

	^ self newVerticalPane
]

{ #category : #adding }
SpToploPanedAdapter >> remove: aPresenter [

	| aBlElement adapter |
	adapter := aPresenter adapter.
	adapter ifNil: [ ^ self ].
	
	adapter unsubscribe.
	aBlElement := adapter widget.
	
	aBlElement parent = widget ifTrue: [
		widget removeChild: aBlElement ]
]
