Class {
	#name : #SpToploComponentListAdapter,
	#superclass : #SpToploAbstractListAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'instance creation' }
SpToploComponentListAdapter >> newItemElementFor: itemPresenter [

	^ itemPresenter build
]
