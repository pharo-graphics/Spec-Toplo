"
I'm a Spec adapter for `SpSearchInputFieldPresenter`.
"
Class {
	#name : #SpToploSearchInputFieldAdapter,
	#superclass : #SpToploTextInputFieldAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #protocol }
SpToploSearchInputFieldAdapter >> takeKeyboardFocus [

	self flag: #toImplement
]
