Class {
	#name : #SpToploTextAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
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

{ #category : #running }
SpToploTextAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #running }
SpToploTextAdapterTest >> tearDown [

	application ifNotNil: [
		application windows do: [ :each | each delete ] ].
	super tearDown
]

{ #category : #tests }
SpToploTextAdapterTest >> testCursorPosition [

	self buildTextPresenter.

	textPresenter cursorPositionIndex: 4.
	self assert: textPresenter cursorPosition equals: 4 @ 1.

	textPresenter cursorPositionIndex: 5.
	self assert: textPresenter cursorPosition equals: 1 @ 2
]
