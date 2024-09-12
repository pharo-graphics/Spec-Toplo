"
I'm the root element of a `BlSpace` that represents a `SpDialogPresenter`.
"
Class {
	#name : #SpToploDialogElement,
	#superclass : #SpToploWindowElement,
	#instVars : [
		'buttonBar'
	],
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #accessing }
SpToploDialogElement >> buttonBar: aBlElement [

	aBlElement constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	self replaceChild: buttonBar with: aBlElement.
	buttonBar := aBlElement
]

{ #category : #initialization }
SpToploDialogElement >> initialize [

	super initialize.

	buttonBar := self newEmptyElement.

	self addChild: buttonBar as: #buttonBar
]

{ #category : #removing }
SpToploDialogElement >> removeButtonBar [

	self buttonBar: self newEmptyElement
]
