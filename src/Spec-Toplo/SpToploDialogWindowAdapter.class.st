Class {
	#name : #SpToploDialogWindowAdapter,
	#superclass : #SpToploWindowLikeAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #API }
SpToploDialogWindowAdapter >> addPresenterIn: aBlSpace withSpecLayout: aSpExecutableLayout [

	super addPresenterIn: aBlSpace withSpecLayout: aSpExecutableLayout.
	
	self updateButtonBar
]

{ #category : #hook }
SpToploDialogWindowAdapter >> newRootElement [

	^ SpToploDialogElement new
]

{ #category : #'as yet unclassified' }
SpToploDialogWindowAdapter >> updateButtonBar [
	"Inspired by SpMorphicDialogWindowAdapter>>#buildButtonBar"

	| aButtonBar |
	aButtonBar := (SpButtonBarPresenter owner: model)
		              placeAtEnd;
		              yourself.

	model buttons do: [ :each | aButtonBar add: each ].

	widget root buttonBar: aButtonBar build
]
