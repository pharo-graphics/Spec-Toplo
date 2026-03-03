"
I'm a Spec adapter for `SpNumberInputFieldPresenter`.
"
Class {
	#name : #SpToploNumberInputFieldAdapter,
	#superclass : #SpToploTextInputFieldAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploNumberInputFieldAdapter >> buildWidget [

	^ ToTextField new inputFilter: AlbTextEditorDigitInputFilter new
]
