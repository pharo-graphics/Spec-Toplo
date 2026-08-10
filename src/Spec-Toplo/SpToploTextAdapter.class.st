"
I'm a Spec adapter for `SpTextPresenter`.
"
Class {
	#name : #SpToploTextAdapter,
	#superclass : #SpToploAbstractTextAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'accessing - text' }
SpToploTextAdapter >> appendText: aString [

	self widget text append: aString asRopedText
]

{ #category : #factory }
SpToploTextAdapter >> buildWidget [

	^ ToAlbum new
]

{ #category : #accessing }
SpToploTextAdapter >> cursorPosition [

	| text cursorIndex lineNumber lineStart |
	text := widget text asString.
	cursorIndex := widget cursor position + 1.
	lineNumber := 1.
	lineStart := 1.

	text lineIndicesDo: [ :start :endWithoutDelimiters :end |
			cursorIndex <= end ifTrue: [
				^ (cursorIndex min: endWithoutDelimiters + 1) - start + 1
				  @ lineNumber ].
			lineNumber := lineNumber + 1.
			lineStart := end + 1 ].

	^ cursorIndex - lineStart + 1 @ lineNumber
]

{ #category : #protocol }
SpToploTextAdapter >> takeKeyboardFocus [

	self flag: #toBeImplemented
]
