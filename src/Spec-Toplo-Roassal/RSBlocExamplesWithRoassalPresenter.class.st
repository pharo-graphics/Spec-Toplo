"
I am a browser for Roassal-Bloc examples.

Also, I show how to use a `SpBlocPresenter`.
"
Class {
	#name : #RSBlocExamplesWithRoassalPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'examplesList',
		'visualization',
		'examplesClass'
	],
	#category : #'Spec-Toplo-Roassal-RoassalPresenterExamples'
}

{ #category : #examples }
RSBlocExamplesWithRoassalPresenter class >> exampleOpenRSBlocExamples [

	| app presenter |
	app := SpApplication new.
	app useBackend: #Toplo.

	presenter := self newApplication: app model: RSBlocExamplesWithParametricCanvas.
	presenter open
]

{ #category : #initialization }
RSBlocExamplesWithRoassalPresenter >> connectPresenters [

	super connectPresenters.

	examplesList
		whenSelectionChangedDo: [ :aSelection | 
			self refreshAccordingToSelectedExample ];
		whenActivatedDo: [ :aSelection | 
			(examplesClass >> aSelection selectedItem) browse ]
]

{ #category : #layout }
RSBlocExamplesWithRoassalPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  borderWidth: 10;
		  add: (SpPanedLayout newHorizontal
			  positionOfSlider: 33 percent;
			  add: #examplesList;
			  add: #visualization;
			  yourself);
		  yourself
]

{ #category : #initialization }
RSBlocExamplesWithRoassalPresenter >> initializePresenters [ 

	super initializePresenters.
	
	examplesList := self newList.
	visualization := self newRoassal.

	self refresh.
]

{ #category : #initialization }
RSBlocExamplesWithRoassalPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Roassal Examples Browser - ', examplesClass name;
		initialExtent: 800 @ 600;
		centered
]

{ #category : #initialization }
RSBlocExamplesWithRoassalPresenter >> refresh [

	examplesList
		unselectAll;
		items: examplesClass allExampleSelectors.

	self refreshAccordingToSelectedExample
]

{ #category : #initialization }
RSBlocExamplesWithRoassalPresenter >> refreshAccordingToSelectedExample [

	examplesList selectedItem
		ifNil: [ self showNullVisualization ]
		ifNotNil: [ :item | self showVisualizationFor: item ]
]

{ #category : #initialization }
RSBlocExamplesWithRoassalPresenter >> setModelBeforeInitialization: aClass [

	examplesClass := aClass
]

{ #category : #initialization }
RSBlocExamplesWithRoassalPresenter >> showNullVisualization [

	visualization script: [ :canvas | ]
]

{ #category : #initialization }
RSBlocExamplesWithRoassalPresenter >> showVisualizationFor: aSelector [

	visualization script: [ :canvas |
		examplesClass new perform: aSelector with: canvas ]
]
