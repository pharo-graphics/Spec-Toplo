"
I adapt SpAthensPresenter for Toplo.
"
Class {
	#name : #SpToploAthensAdapter,
	#superclass : #SpToploWidgetAdapter,
	#instVars : [
		'surface'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploAthensAdapter >> buildWidget [

	^ ToElement new
		  matchParent;
		  yourself
]

{ #category : #drawing }
SpToploAthensAdapter >> redraw [

	| extent |
	widget ifNil: [ ^ self ].
	extent := widget extent.
	(extent x <= 0 or: [ extent y <= 0 ]) ifTrue: [ extent := model surfaceExtent ifNil: [ 100 @ 100 ] ].
	(surface isNil or: [ surface extent ~= extent ]) ifTrue: [ surface := AthensAeCairoSurface extent: extent ].
	model drawBlock ifNotNil: [ :block | surface drawDuring: [ :canvas | block cull: canvas cull: (0 @ 0 extent: extent) ] ].
	widget background: (BlImageBackground image: surface asForm).
	widget invalidate
]

{ #category : #initialization }
SpToploAthensAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	model whenDrawBlockChangedDo: [ :newBlock | self redraw ].
	model whenExtentChangedDo: [ :newExtent |
		widget size: newExtent.
		self redraw ].
	self redraw
]

{ #category : #initialization }
SpToploAthensAdapter >> subscribeToWidget [

	super subscribeToWidget.

	self
		subscribeToWidgetEvent: BlElementExtentChangedEvent
		do: [ :event | self redraw ]
]

{ #category : #accessing }
SpToploAthensAdapter >> surface [

	^ surface
]
