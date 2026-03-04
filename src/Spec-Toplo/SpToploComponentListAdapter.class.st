"
I'm a Spec adapter for `SpComponentListPresenter`.
"
Class {
	#name : #SpToploComponentListAdapter,
	#superclass : #SpToploAbstractListAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'instance creation' }
SpToploComponentListAdapter >> newItemElementFor: itemPresenter [

	^ itemPresenter build
]

{ #category : #protocol }
SpToploComponentListAdapter >> takeKeyboardFocus [

	self flag: #toImplement
]
