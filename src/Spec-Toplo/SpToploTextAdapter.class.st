Class {
	#name : #SpToploTextAdapter,
	#superclass : #SpToploAbstractTextAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTextAdapter >> buildWidget [

	^ ToAlbum new
]

{ #category : #initialization }
SpToploTextAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenEditableChangedDo: [
		self updateEditable ]
]

{ #category : #initialization }
SpToploTextAdapter >> updateEditable [

	model isEditable
		ifTrue: [ widget beEditable ]
		ifFalse: [ widget beReadonlyWithSelection ]
]
