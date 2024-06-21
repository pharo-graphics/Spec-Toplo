Class {
	#name : #SpToploDropListAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploDropListAdapter >> buildWidget [

	^ ToSingleSelectElement new
]

{ #category : #accessing }
SpToploDropListAdapter >> selectedIndexes [

	^ widget selecter selectedIndexes
]

{ #category : #initialization }
SpToploDropListAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model model whenChangedDo: [
		self
			updateItems;
			updateSelection ].
	model selection whenChangedDo: [ self updateSelection ]
]

{ #category : #initialization }
SpToploDropListAdapter >> updateAll [

	super updateAll.

	self
		updateItems;
		updateSelection
]

{ #category : #updating }
SpToploDropListAdapter >> updateItems [

	widget dataAccessor
		removeAll;
		addAll: model items
]

{ #category : #private }
SpToploDropListAdapter >> updateSelection [

	widget selecter selectIndex: model selectedIndex
]
