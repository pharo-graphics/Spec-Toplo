"
I'm a Spec adapter for `SpTextPresenter`.
"
Class {
	#name : #SpToploTextAdapter,
	#superclass : #SpToploAbstractTextAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTextAdapter >> buildWidget [

	^ ToAlbum new
]
