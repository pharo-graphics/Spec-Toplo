"
I am a browser for Roassal-Bloc examples.

Also, I show how to use a `SpBlocPresenter`.
"
Class {
	#name : #RSToploRoassalExamplePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'roassal'
	],
	#category : #'Spec-Toplo-Roassal'
}

{ #category : #examples }
RSToploRoassalExamplePresenter class >> exampleRoassalPresenterInToplo [

	| app presenter |
	app := SpApplication new.
	app useBackend: #Toplo.

	presenter := self newApplication: app.
	presenter open
]

{ #category : #initialization }
RSToploRoassalExamplePresenter >> buildInCanvas: canvas [
	"This is a demo script"

	| y p |
	y := {
		     { 1. 2. 3. 4. 5 }.
		     { 5. 6. 7. 5. 10 }.
		     { 12. 12. 13. 14. 15. 24 } }.
	p := RSBoxPlot new y: y.

	p horizontalTick numberOfTicks: y size.
	p xlabel: 'X Axis'.
	p verticalTick
		numberOfTicks: 10;
		asFloat.
	p ylabel: 'Y Axis'.
	p title: 'Box Plot'.
	p container: canvas.
	canvas @ RSCanvasController.
	p build
]

{ #category : #layout }
RSToploRoassalExamplePresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  borderWidth: 10;
		  add: #roassal;
		  yourself
]

{ #category : #initialization }
RSToploRoassalExamplePresenter >> initializePresenters [

	super initializePresenters.

	roassal := self newRoassal.
	roassal script: [ :canvas | self buildInCanvas: canvas ].
	roassal refresh
]

{ #category : #initialization }
RSToploRoassalExamplePresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: 'Roassal Presenter in Toplo';
		initialExtent: 800 @ 600;
		centered
]
