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
	contentPresenter := model setupAction value: model.
	model bindAction value: contentPresenter value: anItem.

	toElement := contentPresenter build.
	toElement userData at: #specModel put: anItem.

	^ self prepareEmbeddedItemPanesIn: toElement
]

{ #category : #enumerating }
SpToploTreeListViewAdapter >> traversePresentersDo: aFullBlockClosure excluding: aCollection [

	self flag: #toImplement
]
