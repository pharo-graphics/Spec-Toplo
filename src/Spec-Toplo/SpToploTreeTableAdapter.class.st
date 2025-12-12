Class {
	#name : #SpToploTreeTableAdapter,
	#superclass : #SpToploTableAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTreeTableAdapter >> buildWidget [

	widget := ToTreeTableElement new.
	widget showHeader: self model isShowingColumnHeaders.
	widget selecter multiple: self model selectionMode isMultipleSelection.
	widget columns: self buildColumns.
	widget nodeManager childrenGetter: self model children.
	^ widget
]

{ #category : #'expanding-collapsing' }
SpToploTreeTableAdapter >> expandAll [
	widget list expandAll
]

{ #category : #factory }
SpToploTreeTableAdapter >> itemAtPath: aPath [

	^ (widget dataAccessor dataSource itemsAtPath: aPath) last
]

{ #category : #initialization }
SpToploTreeTableAdapter >> subscribeToPresenter [

	model
		whenRootsChangedDo: [ self updateItems ];
		whenSelectionChangedDo: [ self updateSelection ]
]

{ #category : #factory }
SpToploTreeTableAdapter >> subscribeToWidget [

	widget list
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [ :event |
			model selection selectPath: widget list selecter selectedIndexes.
			  ];
		addEventHandlerOn: ToListStrongSelectionEvent
		do: [ model doActivateAtIndex: model selection selectedIndex ]
]

{ #category : #factory }
SpToploTreeTableAdapter >> updateItems [

	widget dataAccessor
		removeAll;
		addAll: model roots
]

{ #category : #factory }
SpToploTreeTableAdapter >> updateSelection [

	model selection selectedPaths ifEmpty: [
		^ widget selecter deselectAll ].
	widget selecter selectIndex: model selection selectedPaths
]
