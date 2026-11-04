Class {
	#name : #SpToploPanedAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #running }
SpToploPanedAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #running }
SpToploPanedAdapterTest >> tearDown [

	application ifNotNil: [ application windows do: [ :each | each delete ] ].
	super tearDown
]

{ #category : #tests }
SpToploPanedAdapterTest >> testBoxLayoutBorderWidth [

	| presenter layout widget |
	presenter := SpPresenter newApplication: application.
	layout := SpBoxLayout newVertical
		borderWidth: 15;
		add: (presenter newLabel label: 'Test');
		yourself.
	presenter layout: layout.
	presenter build.
	widget := presenter adapter widget.
	self assert: widget padding equals: (BlInsets all: 15)
]

{ #category : #tests }
SpToploPanedAdapterTest >> testBoxLayoutSpacing [

	| presenter layout startPane |
	presenter := SpPresenter newApplication: application.
	layout := SpBoxLayout newVertical
		spacing: 20;
		add: (presenter newLabel label: 'First');
		add: (presenter newLabel label: 'Second');
		yourself.
	presenter layout: layout.
	presenter build.
	startPane := presenter adapter instVarNamed: #startPane.
	self assert: startPane layout interspace equals: 20
]

{ #category : #tests }
SpToploPanedAdapterTest >> testHorizontalPanedContainsBothChildrenAndDivider [

	| presenter left right widget |
	presenter := SpPresenter newApplication: application.
	left := presenter newLabel label: 'Left'.
	right := presenter newLabel label: 'Right'.
	presenter layout: (SpPanedLayout newHorizontal
			 add: left;
			 add: right;
			 yourself).
	presenter build.
	widget := presenter adapter widget.
	self assert: widget isHorizontal.
	self assert: widget dividers size equals: 1.
	self assert: (widget children includes: left adapter widget).
	self assert: (widget children includes: right adapter widget)
]

{ #category : #tests }
SpToploPanedAdapterTest >> testVerticalPanedContainsBothChildrenAndDivider [

	| presenter top bottom widget |
	presenter := SpPresenter newApplication: application.
	top := presenter newLabel label: 'Top'.
	bottom := presenter newLabel label: 'Bottom'.
	presenter layout: (SpPanedLayout newVertical
			 add: top;
			 add: bottom;
			 yourself).
	presenter build.
	widget := presenter adapter widget.
	self assert: widget isVertical.
	self assert: widget dividers size equals: 1.
	self assert: (widget children includes: top adapter widget).
	self assert: (widget children includes: bottom adapter widget)
]
