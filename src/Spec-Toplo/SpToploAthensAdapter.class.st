"
I adapt SpAthensPresenter for Toplo.
"
Class {
	#name : #SpToploAthensAdapter,
	#superclass : #SpToploWidgetAdapter,
	#instVars : [
		'athensSurface'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploAthensAdapter >> buildWidget [

	^ BASurfaceElement new
		matchParent;
		addEventHandlerOn: BlElementExtentChangedEvent do: [ :event | self redraw ];
		yourself
]

{ #category : #drawing }
SpToploAthensAdapter >> redraw [

	| extent |
	widget ifNil: [ ^ self ].
	extent := widget extent.
	(extent x <= 0 or: [ extent y <= 0 ]) ifTrue: [ ^ self ].

	(athensSurface isNil or: [ athensSurface extent ~= extent ]) ifTrue: [
		athensSurface := AthensAeCairoSurface extent: extent ].

	model drawBlock ifNotNil: [ :block |
		athensSurface drawDuring: [ :canvas |
			block cull: canvas cull: (0 @ 0 extent: extent) ] ].

	self flag: #todo. "Assumes the renderer is Bloc-Alexandrie"
	widget surface: athensSurface cairoSurface.
	widget invalidate
]

{ #category : #initialization }
SpToploAthensAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model
		whenDrawBlockChangedDo: [ :newBlock | self redraw ];
		whenExtentChangedDo: [ :newExtent |
			widget extent: newExtent.
			self redraw ]
]

{ #category : #accessing }
SpToploAthensAdapter >> surface [

	^ athensSurface
]

{ #category : #initialization }
SpToploAthensAdapter >> updateAll [

	super updateAll.

	self redraw
]
