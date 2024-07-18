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

	^ ToSingleSelectElement new
		listNodeBuilder: [ :node :holder |
			self newItemElementFor: node holder: holder ];
		dataViewBuilder: [ :dataItemView :iconDesc |
			dataItemView selectedDataTextField text: (model displayForItem: (model getList at: model selectedIndex)).
"			model hasIcons ifTrue: [
				dataItemView addChild: (ToImage inner: (model getIconFor: (model getList at: model selectedIndex))) ]" ];
		yourself

]

{ #category : #factory }
SpToploDropListAdapter >> newItemElementFor: node holder: holder [

	model hasIcons ifFalse: [
		^ node addChild:
			(ToLabel text: (model displayForItem: holder) asRopedText)
				hMatchParent;
				yourself ].

	node addChild:
		(ToLabeledIcon new
			labelText: (model displayForItem: holder);
			icon: (ToImage inner: (model getIconFor: holder));
			startInterspace: 10;
			hMatchParent;
			yourself)
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

	widget dataAccessor
		removeAll;
		addAll: model getList
]

{ #category : #'updating widget' }
SpToploDropListAdapter >> updateSelection [

	widget selecter selectIndex: model selectedIndex
]
