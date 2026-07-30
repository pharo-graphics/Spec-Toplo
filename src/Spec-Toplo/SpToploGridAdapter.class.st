"
I'm a Spec adapter for `SpGridLayout`.
"
Class {
	#name : #SpToploGridAdapter,
	#superclass : #SpToploLayoutAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploGridAdapter >> addChildElement: aToLabel with: aSpGridConstraints [

	widget addChild: aToLabel
]

{ #category : #adding }
SpToploGridAdapter >> addConstraints: constraints toChild: childBlElement [

	childBlElement constraintsDo: [ :c |
			self model layout isColumnHomogeneous ifFalse: [ childBlElement fitContent ].
			constraints span ifNotNil: [
					c grid horizontal span: constraints span x.
					c grid vertical span: constraints span y ] ].
	^ childBlElement
]

{ #category : #'instance creation' }
SpToploGridAdapter >> newChildBlElement: aPresenter constrainedBy: constraints [
	^ self newBlElementFrom: aPresenter constraints: constraints
]

{ #category : #'instance creation' }
SpToploGridAdapter >> newToploWidget [

	| gridLayout |
	gridLayout := BlGridLayout horizontal.
	gridLayout columnCount:
		((layout children values collect: [ :value | value position x ]) ifNotEmpty: [ :col | col max ] ifEmpty: [ 0 ]).
	gridLayout rowCount:
		((layout children values collect: [ :value | value position y ]) ifNotEmpty: [ :col | col max ] ifEmpty: [ 0 ]).
	^ ToPane new
		  layout: gridLayout;
		  yourself
]
