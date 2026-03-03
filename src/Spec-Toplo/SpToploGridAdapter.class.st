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

{ #category : #'instance creation' }
SpToploGridAdapter >> addConstraints: constraints toChild: childBlElement [

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
		(layout children values collect: [ :value | value position x ]) max.
	gridLayout rowCount:
		(layout children values collect: [ :value | value position y ]) max.
	^ ToPane new
		  layout: gridLayout;
		  yourself
]
