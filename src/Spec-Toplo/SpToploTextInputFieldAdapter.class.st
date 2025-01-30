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

{ #category : #testing }
SpToploTextInputFieldAdapter >> isPassword [
	
	^ eventHandler isPassword
]

{ #category : #initialization }
SpToploTextInputFieldAdapter >> newTextEventHandler [

	^ SpToploTextInputFieldEventHandler new
]

{ #category : #initialization }
SpToploTextInputFieldAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenPasswordChangedDo: [ self updateIsPassword ]
]

{ #category : #initialization }
SpToploTextInputFieldAdapter >> updateAll [

	super updateAll.

	self updateIsPassword
]

{ #category : #initialization }
SpToploTextInputFieldAdapter >> updateIsPassword [

	eventHandler bePassword: model isPassword
]
