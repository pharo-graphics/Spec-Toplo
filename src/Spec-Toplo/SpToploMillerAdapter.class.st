Class {
	#name : #SpToploMillerAdapter,
	#superclass : #SpToploLayoutAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploMillerAdapter >> addChildElement: aWidget with: aSpGridConstraints [

	widget addChild: aWidget
]

{ #category : #'instance creation' }
SpToploMillerAdapter >> addConstraints: constraints toChild: childBlElement [

	^ childBlElement
]

{ #category : #'instance creation' }
SpToploMillerAdapter >> newChildBlElement: aPresenter constrainedBy: constraints [
	^ self newBlElementFrom: aPresenter constraints: constraints
]

{ #category : #'instance creation' }
SpToploMillerAdapter >> newToploWidget [

	^ ToPane horizontal
		  matchParent;
		  yourself
]

{ #category : #adding }
SpToploMillerAdapter >> remove: aStObjectInspectorPresenter [

	self widget removeChild: aStObjectInspectorPresenter adapter widget
]
