"
I'm a Spec adapter for `SpPaginatorPresenter`.
"
Class {
	#name : #SpToploPaginatorAdapter,
	#superclass : #SpToploWidgetAdapter,
	#instVars : [
		'list'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploPaginatorAdapter >> buildWidget [

	| rootPane  |
	rootPane := ToPane horizontal.
	rootPane layout alignCenter.
	rootPane matchParent.
	list := ToCheckableListElement finite.
	list
		beHorizontal;
		matchParent;
		addAllItems: (self model pages collect: [ :aPageDescription |
					 self entryForPage: aPageDescription ]).
	rootPane addChild: list.
	^ rootPane
]

{ #category : #'as yet unclassified' }
SpToploPaginatorAdapter >> entryForPage: aPageDescription [

	^ ToToggleButton new
		  iconImage: (self iconNamed: #solidMenu);
		  yourself
]

{ #category : #factory }
SpToploPaginatorAdapter >> list [

	^ widget childAt: 1
]

{ #category : #factory }
SpToploPaginatorAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenPageAddedDo: [ :anObject |
		self list addItem: (self entryForPage: anObject) ].
	model whenPageRemovedDo: [ :anObject |
		anObject ifNil: [ self list removeAllItems ] ifNotNil: [ self halt ] ]
]

{ #category : #factory }
SpToploPaginatorAdapter >> subscribeToWidget [

	super subscribeToWidget.
	list
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [ :event |
				event selectedIndexes ifNotEmpty: [
					self presenter selectPage: event selectedIndexes anyOne ] ]
]
