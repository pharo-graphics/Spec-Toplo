"
I'm a Spec adapter for `SpTextInputFieldPresenter`.
"
Class {
	#name : #SpToploTextInputFieldAdapter,
	#superclass : #SpToploAbstractTextAdapter,
	#instVars : [
		'passwordHandler'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTextInputFieldAdapter >> buildWidget [

	^ ToTextField new
]

{ #category : #initialization }
SpToploTextInputFieldAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenPasswordChangedDo: [ self updatePassword ]
]

{ #category : #initialization }
SpToploTextInputFieldAdapter >> switchToPasswordMode [

	widget removeEventHandler: plainTextHandler.

	passwordHandler :=
		SpToploPasswordFieldEventHandler new
			adapter: self;
			yourself.
	widget addEventHandler: passwordHandler
]

{ #category : #initialization }
SpToploTextInputFieldAdapter >> switchToPlainTextMode [

	widget removeEventHandler: passwordHandler.

	self setPresenterText: model text.
	
	widget addEventHandler: plainTextHandler.
	passwordHandler := nil
]

{ #category : #initialization }
SpToploTextInputFieldAdapter >> updateAll [

	super updateAll.

	self updatePassword
]

{ #category : #initialization }
SpToploTextInputFieldAdapter >> updatePassword [

	"Return early if we are done."
	model isPassword = passwordHandler isNotNil ifTrue: [ ^ self ].

	model isPassword
		ifTrue: [ self switchToPasswordMode ]
		ifFalse: [ self switchToPlainTextMode ]
]
