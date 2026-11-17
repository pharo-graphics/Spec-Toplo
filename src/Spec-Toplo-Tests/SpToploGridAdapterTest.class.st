Class {
	#name : #SpToploGridAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'window'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #running }
SpToploGridAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #running }
SpToploGridAdapterTest >> tearDown [

	window ifNotNil: [
		window close.
		window := nil ].
	super tearDown
]

{ #category : #tests }
SpToploGridAdapterTest >> testNonHomogeneousGridWithExpandableColumn [

	| presenter label input gridLayout |
	presenter := application instantiate: SpPresenter.
	label := presenter newLabel label: 'Repository Name:'.
	input := presenter newTextInput.

	gridLayout := SpGridLayout new
		beColumnNotHomogeneous;
		column: 2 expand: true;
		add: label atPoint: 1 @ 1;
		add: input atPoint: 2 @ 1;
		yourself.

	presenter layout: gridLayout.
	window := presenter asWindow.
	window open.
	window adapter widget settle.

	self assert: label adapter widget width < input adapter widget width.
	self assert: input adapter widget width > 100.
	self assert: input adapter widget height >= 20
]
