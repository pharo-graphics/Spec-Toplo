"
I'm a Spec adapter for `SpListPresenter`.
"
Class {
	#name : #SpToploListAdapter,
	#superclass : #SpToploWidgetAdapter,
	#traits : 'SpToploTWithContextMenu',
	#classTraits : 'SpToploTWithContextMenu classTrait',
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploListAdapter >> buildWidget [

	^ ToListElement new
		nodeBuilder: [ :node :holder |
		  self newItemElementFor: node holder: holder ];
		yourself
]

{ #category : #accessing }
SpToploListAdapter >> elementAt: anInteger [ 
	
	^ widget dataAccessor at: anInteger
]

{ #category : #testing }
SpToploListAdapter >> isNonEditableRow: aRow column: aColumn [

	self flag: #todo.
	^ true
]

{ #category : #'instance creation' }
SpToploListAdapter >> newItemElementFor: node holder: holder [

	self model hasIcons ifFalse: [ 
		^ node addChild:
			(ToLabel text: holder dataItem asString)
				hMatchParent;
				yourself ].

	node addChild:
		(ToLabeledIcon new
			label: (ToLabel
				text: (model displayValueFor: holder dataItem) asRopedText);
			icon: (ToImage inner: (model iconFor: holder dataItem));
			startInterspace: 10;
			hMatchParent;
			yourself)
]

{ #category : #refreshing }
SpToploListAdapter >> refreshList [

]

{ #category : #factory }
SpToploListAdapter >> refreshWidgetList [

	widget notifyDataSourceChanged
]

{ #category : #accessing }
SpToploListAdapter >> refreshWidgetSelection [

	self updateSelection
]

{ #category : #accessing }
SpToploListAdapter >> selectIndex: anInteger [ 
	
	widget selecter selectOnlyIndex: anInteger
]

{ #category : #accessing }
SpToploListAdapter >> selectedIndexes [
	
	^ widget selecter selectedIndexes
]

{ #category : #initialization }
SpToploListAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model
		whenModelChangedDo: [ self updateItems ];
		whenSelectionChangedDo: [ self updateSelection ];
		whenIconsChangedDo: [ self refreshWidgetList ]
]

{ #category : #initialization }
SpToploListAdapter >> subscribeToWidget [

	super subscribeToWidget.

	widget
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
			do: [ model selection selectIndexes: widget selecter selectedIndexes ];
		addEventHandlerOn: ToListStrongSelectionEvent
			do: [ model doActivateAtIndex: model selection selectedIndex ]
]

{ #category : #'updating widget' }
SpToploListAdapter >> updateAll [

	super updateAll.

	self
		updateItems;
		updateSelection;
		updateMenu
]

{ #category : #'updating widget' }
SpToploListAdapter >> updateItems [

	widget dataAccessor
		removeAll;
		addAll: model items
]

{ #category : #'updating widget' }
SpToploListAdapter >> updateSelection [

	widget selecter selectIndexes: model selection selectedIndexes
]
