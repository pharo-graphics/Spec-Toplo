Class {
	#name : #SpToploTreeListViewAdapter,
	#superclass : #SpToploTreeAdapter,
	#traits : 'SpToploTWithEmbeddedListItem',
	#classTraits : 'SpToploTWithEmbeddedListItem classTrait',
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTreeListViewAdapter >> newItemElementFor: anItem [
	"Build a list item from the presenter factory used by SpListViewPresenter and SpTreeListViewPresenter."

	| contentPresenter toElement |
	contentPresenter := self model setupAction value: self model.
	self model bindAction value: contentPresenter value: anItem.

	toElement := contentPresenter build.
	toElement userData at: #specModel put: anItem.

	^ self prepareEmbeddedItemPanesIn: toElement
]

{ #category : #protocol }
SpToploTreeListViewAdapter >> takeKeyboardFocus [
	self widget requestFocus
]
