Class {
	#name : #SpToploPaginatorAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploPaginatorAdapter >> buildWidget [

	^ ToCheckableListElement new
		  beHorizontal;
		  addAllItems: (self model pages collect: [ :aPageDescription |
					   self entryForPage: aPageDescription ]);
		  yourself
]

{ #category : #'as yet unclassified' }
SpToploPaginatorAdapter >> entryForPage: aPageDescription [

	^ ToToggleButton new
		  icon: (ToImage new innerImage: (self iconNamed: #solidMenu));
		  yourself
]

{ #category : #factory }
SpToploPaginatorAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenPageAddedDo: [ :anObject |
		widget addItem: (self entryForPage: anObject) ].
	model whenPageRemovedDo: [ :anObject |
		anObject ifNil: [ widget removeAllItems ] ifNotNil: [ self halt ] ]
]
