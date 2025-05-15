"
I'm a Spec adapter for `SpDropListPresenter`.
"
Class {
	#name : #SpToploDropListAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploDropListAdapter >> buildWidget [

	| aSelect |
	aSelect := ToSingleSelectElement new.

	aSelect dataViewBuilder: [ :node :dataItem |
		node addChild: (self newItemElementFor: dataItem) ].

	aSelect popupListElement nodeBuilder: [ :node :dataItem |
		node addChild: (self newItemElementFor: dataItem) ].

	^ aSelect
]

{ #category : #accessing }
SpToploDropListAdapter >> elementAt: index [

	^ model getList at: index
]

{ #category : #factory }
SpToploDropListAdapter >> newItemElementFor: aSpDropListItem [

	model hasIcons ifFalse: [
		^ ToLabel new
			text: (model displayForItem: aSpDropListItem) asRopedText;
			hMatchParent;
			yourself ].

	^ ToLabeledIcon new
		labelText: (model displayForItem: aSpDropListItem);
		icon: (ToImage inner: (model getIconFor: aSpDropListItem));
		startInterspace: 10;
		hMatchParent;
		yourself
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

{ #category : #'updating widget' }
SpToploDropListAdapter >> updateAll [

	super updateAll.

	self
		updateItems;
		updateSelection
]

{ #category : #'updating widget' }
SpToploDropListAdapter >> updateItems [

	widget popupListElement dataAccessor
		removeAll;
		addAll: model getList
]

{ #category : #'updating widget' }
SpToploDropListAdapter >> updateSelection [

	widget selecter selectIndex: model selectedIndex
]
