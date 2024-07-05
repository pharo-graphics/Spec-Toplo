"
I'm a Spec adapter for `SpTextInputFieldPresenter`.
"
Class {
	#name : #SpToploTextInputFieldAdapter,
	#superclass : #SpToploAbstractTextAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTextInputFieldAdapter >> buildWidget [

	^ ToTextField new
]
