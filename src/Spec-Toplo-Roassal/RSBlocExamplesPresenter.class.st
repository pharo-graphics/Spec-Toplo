"
I am a browser for Roassal-Bloc examples.

Also, I show how to use a `SpBlocPresenter`.
"
Class {
	#name : #RSBlocExamplesPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'examplesList',
		'visualization',
		'examplesClass'
	],
	#category : #'Spec-Toplo-Roassal'
}

{ #category : #layout }
RSBlocExamplesPresenter class >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  borderWidth: 10;
		  add: (SpPanedLayout newHorizontal
			  positionOfSlider: 33 percent;
			  add: #examplesList;
			  add: #visualization;
			  yourself);
		  yourself
]

{ #category : #examples }
RSBlocExamplesPresenter class >> exampleOpenRSBlocExamples [

	| app presenter |
	app := SpApplication new.
	app useBackend: #Toplo.

	presenter := self newApplication: app model: RSBlocExamples.
	presenter open
]

{ #category : #initialization }
RSBlocExamplesPresenter >> connectPresenters [

	super connectPresenters.

	examplesList
		whenSelectionChangedDo: [ :aSelection | 
			self refreshAccordingToSelectedExample ];
		whenActivatedDo: [ :aSelection | 
			(examplesClass >> aSelection selectedItem) browse ]
]

{ #category : #initialization }
RSBlocExamplesPresenter >> initializePresenters [ 

	super initializePresenters.
	
	examplesList := self newList.
	visualization := self instantiate: SpBlocPresenter.

	self refresh.
]

{ #category : #initialization }
RSBlocExamplesPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Roassal Examples Browser - ', examplesClass name;
		initialExtent: 800 @ 600;
		centered
]

{ #category : #initialization }
RSBlocExamplesPresenter >> refresh [

	examplesList
		unselectAll;
		items: examplesClass allExampleSelectors.

	self refreshAccordingToSelectedExample
]

{ #category : #initialization }
RSBlocExamplesPresenter >> refreshAccordingToSelectedExample [

	examplesList selectedItem
		ifNil: [ self showNullVisualization ]
		ifNotNil: [ :item | self showVisualizationFor: item ]
]

{ #category : #initialization }
RSBlocExamplesPresenter >> setModelBeforeInitialization: aClass [

	examplesClass := aClass
]

{ #category : #initialization }
RSBlocExamplesPresenter >> showNullVisualization [

	visualization blocElement: nil
]

{ #category : #initialization }
RSBlocExamplesPresenter >> showVisualizationFor: aSelector [

	| aRSCanvas |
	aRSCanvas := examplesClass new perform: aSelector.
	aRSCanvas useBlocHost.
	visualization blocElement: aRSCanvas host canvasElement
]
