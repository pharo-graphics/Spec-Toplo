Class {
	#name : #SpToploTextAdapterTest,
	#superclass : #SpToploAbstractAdapterTest,
	#instVars : [
		'textPresenter'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #helpers }
SpToploTextAdapterTest >> buildTextPresenter [

	textPresenter := SpTextPresenter new.
	textPresenter application: application.
	textPresenter text: 'abc' , String cr , 'de'.
	textPresenter build
]

{ #category : #tests }
SpToploTextAdapterTest >> testCursorPosition [

	self buildTextPresenter.

	textPresenter cursorPositionIndex: 4.
	self assert: textPresenter cursorPosition equals: 4 @ 1.

	textPresenter cursorPositionIndex: 5.
	self assert: textPresenter cursorPosition equals: 1 @ 2
]
