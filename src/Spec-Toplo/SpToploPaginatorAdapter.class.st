Class {
	#name : #SpToploPaginatorAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploPaginatorAdapter >> buildWidget [

	| rootPane list |
	rootPane := ToPane horizontal.
	rootPane layout alignCenter.
	rootPane matchParent.
	list := ToCheckableListElement new
		        beHorizontal;
		        matchParent;
		        addAllItems:
			        (self model pages collect: [ :aPageDescription |
					         self entryForPage: aPageDescription ]);
		        yourself.
	rootPane addChild: list.
	^ rootPane
]

{ #category : #'as yet unclassified' }
SpToploPaginatorAdapter >> entryForPage: aPageDescription [

	^ ToToggleButton new
		  icon: (ToImage new innerImage: (self iconNamed: #solidMenu));
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
