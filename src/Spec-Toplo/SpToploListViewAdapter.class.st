"
I'm a Spec adapter for `SpListPresenter`.
"
Class {
	#name : #SpToploListViewAdapter,
	#superclass : #SpToploAbstractListAdapter,
	#traits : 'SpToploTWithEmbeddedListItem',
	#classTraits : 'SpToploTWithEmbeddedListItem classTrait',
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #protocol }
SpToploListViewAdapter >> takeKeyboardFocus [
]

{ #category : #enumerating }
SpToploListViewAdapter >> traversePresentersDo: aFullBlockClosure excluding: aCollection [ 
	self flag: #toImplement
]
