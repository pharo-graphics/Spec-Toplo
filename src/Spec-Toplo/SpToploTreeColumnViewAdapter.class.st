"
I'm a Spec adapter for `SpTreeTablePresenter`.
"
Class {
	#name : #SpToploTreeColumnViewAdapter,
	#superclass : #SpToploColumnViewAdapter,
	#traits : 'SpToploTTreeHelper',
	#classTraits : 'SpToploTTreeHelper classTrait',
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTreeColumnViewAdapter >> buildWidget [

	widget := ToTreeTableElement new.
	widget useScrollbar: true.
	widget showHeader: self model isShowingColumnHeaders.
	widget selecter multiple:
		self model selectionMode isMultipleSelection.
	widget columns: self buildColumns.
	widget nodeManager childrenGetter: [ :dataItem |
		model childrenFor: dataItem ].
	^ widget
]

{ #category : #testing }
SpToploTreeColumnViewAdapter >> columnCount [

	^ self widget columns size
]

{ #category : #'expanding-collapsing' }
SpToploTreeColumnViewAdapter >> expandAll [

	widget list expandAll
]

{ #category : #initialization }
SpToploTreeColumnViewAdapter >> initialize [

	super initialize.
	
	suspendUpdateSelection := false
]

{ #category : #factory }
SpToploTreeColumnViewAdapter >> itemAtPath: aPath [

	^ (widget dataAccessor dataSource itemsAtPath: aPath) last dataItem
]

{ #category : #updating }
SpToploTreeColumnViewAdapter >> refreshTree [
	self widget list notifyDataSourceChanged
]

{ #category : #accessing }
SpToploTreeColumnViewAdapter >> scrollToSelection [
	self flag: #toImplement
]

{ #category : #accessing }
SpToploTreeColumnViewAdapter >> selectedItem [

	| selectedIndex |
	selectedIndex := self widget selecter selectedIndex.
	selectedIndex = 0 ifTrue: [ ^ nil ].

	^ (self widget dataSource at: selectedIndex) dataItem
]

{ #category : #initialization }
SpToploTreeColumnViewAdapter >> subscribeToPresenter [

	model
		whenRootsChangedDo: [ self updateItems ];
		whenSelectionChangedDo: [ self updateSelection ]
]

{ #category : #initialization }
SpToploTreeColumnViewAdapter >> subscribeToWidget [

	widget list
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [ :event | self transferSelectionChange: event ];
		addEventHandlerOn: ToListStrongSelectionEvent
		do: [ :event | self transferStrongSelection: event ]
]

{ #category : #initialization }
SpToploTreeColumnViewAdapter >> transferStrongSelection: evt [

	model doActivateAtPath: model selection selectedPath.
]

{ #category : #initialization }
SpToploTreeColumnViewAdapter >> treeWidget [

	^ self widget list
]

{ #category : #'updating widget' }
SpToploTreeColumnViewAdapter >> updateItems [

	widget dataAccessor
		removeAll;
		addAll: model roots
]

{ #category : #'updating widget' }
SpToploTreeColumnViewAdapter >> updateSelection [

	suspendUpdateSelection ifTrue: [ ^ self ].

	model selection selectedPaths ifEmpty: [
		^ widget selecter deselectAll ].

	widget selecter deselectAll.
	model selection selectedPaths do: [ :each | self selectPath: each ]
]

{ #category : #'updating widget' }
SpToploTreeColumnViewAdapter >> updateSelectionMode [

	widget ifNil: [ ^ self ].
	widget selecter multiple:
		self model selectionMode isMultipleSelection
]
