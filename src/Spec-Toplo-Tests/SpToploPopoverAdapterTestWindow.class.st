Class {
	#name : #SpToploPopoverAdapterTestWindow,
	#superclass : #Object,
	#instVars : [
		'anchorElement',
		'anchorRoot',
		'measuredWidth',
		'measuredHeight',
		'position'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #accessing }
SpToploPopoverAdapterTestWindow >> anchorElement [

	^ anchorElement
]

{ #category : #accessing }
SpToploPopoverAdapterTestWindow >> anchorElement: anObject [

	anchorElement := anObject
]

{ #category : #initialization }
SpToploPopoverAdapterTestWindow >> anchorElement: anAnchorElement anchorRoot: anAnchorRoot measuredWidth: aWidth measuredHeight: aHeight [

	anchorElement := anAnchorElement.
	anchorRoot := anAnchorRoot.
	measuredWidth := aWidth.
	measuredHeight := aHeight
]

{ #category : #accessing }
SpToploPopoverAdapterTestWindow >> anchorRoot [

	^ anchorRoot
]

{ #category : #accessing }
SpToploPopoverAdapterTestWindow >> anchorRoot: anObject [

	anchorRoot := anObject
]

{ #category : #accessing }
SpToploPopoverAdapterTestWindow >> measuredHeight [

	^ measuredHeight
]

{ #category : #accessing }
SpToploPopoverAdapterTestWindow >> measuredHeight: anObject [

	measuredHeight := anObject
]

{ #category : #accessing }
SpToploPopoverAdapterTestWindow >> measuredWidth [

	^ measuredWidth
]

{ #category : #accessing }
SpToploPopoverAdapterTestWindow >> measuredWidth: anObject [

	measuredWidth := anObject
]

{ #category : #accessing }
SpToploPopoverAdapterTestWindow >> position [

	^ position
]

{ #category : #accessing }
SpToploPopoverAdapterTestWindow >> position: aPoint [

	position := aPoint
]
