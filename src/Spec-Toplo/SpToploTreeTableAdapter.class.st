Class {
	#name : #SpToploTreeTableAdapter,
	#superclass : #SpToploTableAdapter,
	#traits : 'SpToploTTreeHelper',
	#classTraits : 'SpToploTTreeHelper classTrait',
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTreeTableAdapter >> buildWidget [

	widget := ToTreeTableElement new.
	widget showHeader: self model isShowingColumnHeaders.
	widget selecter multiple:
		self model selectionMode isMultipleSelection.
	widget columns: self buildColumns.
	widget nodeManager childrenGetter: [ :dataItem |
		model childrenFor: dataItem ].
	^ widget
]

{ #category : #'expanding-collapsing' }
SpToploTreeTableAdapter >> expandAll [

	widget list expandAll
]

{ #category : #initialization }
SpToploTreeTableAdapter >> initialize [

	super initialize.
	
	suspendUpdateSelection := false
]

{ #category : #factory }
SpToploTreeTableAdapter >> itemAtPath: aPath [

	^ (widget dataAccessor dataSource itemsAtPath: aPath) last dataItem
]

{ #category : #accessing }
SpToploTreeTableAdapter >> scrollToSelection [
	self flag: #toImplement
]

{ #category : #initialization }
SpToploTreeTableAdapter >> subscribeToPresenter [

	model
		whenRootsChangedDo: [ self updateItems ];
		whenSelectionChangedDo: [ self updateSelection ]
]

{ #category : #initialization }
SpToploTreeTableAdapter >> subscribeToWidget [

	widget list
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [ :event | self transferSelectionChange: event ];
		addEventHandlerOn: ToListStrongSelectionEvent
		do: [ :event | self transferStrongSelection: event ]
]

{ #category : #initialization }
SpToploTreeTableAdapter >> transferStrongSelection: evt [

	model doActivateAtPath: model selection selectedPath.
]

{ #category : #initialization }
SpToploTreeTableAdapter >> treeWidget [

	^ self widget list
]

{ #category : #'updating widget' }
SpToploTreeTableAdapter >> updateItems [

	widget dataAccessor
		removeAll;
		addAll: model roots
]

{ #category : #'updating widget' }
SpToploTreeTableAdapter >> updateSelection [
	
	
	suspendUpdateSelection ifTrue: [ ^ self ].

	model selection selectedPaths ifEmpty: [
		^ widget selecter deselectAll ].
	model selection selectedPaths do: [ :each | self selectPath: each ]
]
