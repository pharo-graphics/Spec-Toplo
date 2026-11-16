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
		addEventHandlerOn: BlElementExtentChangedEvent do: [ :event | self redraw ];
		yourself
]

{ #category : #drawing }
SpToploAthensAdapter >> redraw [

	| extent |
	widget ifNil: [ ^ self ].
	extent := widget extent.
	(extent x <= 0 or: [ extent y <= 0 ]) ifTrue: [ extent := self presenter surfaceExtent ifNil: [ 100 @ 100 ] ].
	(surface isNil or: [ surface extent ~= extent ]) ifTrue: [ surface := AthensAeCairoSurface extent: extent ].
	self presenter drawBlock ifNotNil: [ :block | surface drawDuring: [ :canvas | block cull: canvas cull: (0 @ 0 extent: extent) ] ].
	widget background: (BlImageBackground image: surface asForm).
	widget invalidate
]

{ #category : #initialization }
SpToploAthensAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	self presenter whenDrawBlockChangedDo: [ :newBlock | self redraw ].
	self presenter whenExtentChangedDo: [ :newExtent |
		widget size: newExtent.
		self redraw ].
	self redraw
]

{ #category : #accessing }
SpToploAthensAdapter >> surface [

	^ surface
]
