"
I'm a Spec adapter for `SpTreePresenter`.
"
Class {
	#name : #SpToploTreeAdapter,
	#superclass : #SpToploWidgetAdapter,
	#instVars : [
		'suspendTransferSelection'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTreeAdapter >> buildWidget [

	| tree |
	tree := ToTreeElement new.
"	tree withRowNumbers. USEFUL TO DEBUG"
	
	tree nodeManager childrenGetter: [ :dataItem |
		model childrenFor: dataItem ].
	
	tree nodeBuilder: [ :node :dataItem :holder |
		node addChild: (self newItemElementFor: dataItem) ].

	^ tree
]

{ #category : #'expanding-collapsing' }
SpToploTreeAdapter >> collapseAll [

	widget collapseAll
]

{ #category : #'expanding-collapsing' }
SpToploTreeAdapter >> expandAll [

	widget expandAll
]

{ #category : #accessing }
SpToploTreeAdapter >> expandPath: aPath [

	widget dataSource itemsAtPath: aPath
]

{ #category : #'expanding-collapsing' }
SpToploTreeAdapter >> expandRoots [

	widget expandRoots
]

{ #category : #selection }
SpToploTreeAdapter >> initialize [

	super initialize.
	
	suspendTransferSelection := false
]

{ #category : #testing }
SpToploTreeAdapter >> isExpanded: item [

	^ widget dataSource collection
		detect: [ :each | each unwrapped = item ]
		ifFound: [ :dataItem | dataItem isExpanded ]
		ifNone: [ false ]
]

{ #category : #private }
SpToploTreeAdapter >> itemAtPath: aPath [

	self suspendSelectionDuring: [
		^ (widget dataSource itemsAtPath: aPath) last unwrapped ]
]

{ #category : #factory }
SpToploTreeAdapter >> newItemElementFor: item [

	model displayIcon ifNil: [
		^ ToLabel new
			text: (model display cull: item) asString asRopedText;
			hMatchParent;
			yourself ].

	^ ToLabeledIcon new
		labelText: (model display cull: item) asString;
		iconImage: (model displayIcon cull: item);
		startInterspace: 10;
		hMatchParent;
		yourself
]

{ #category : #accessing }
SpToploTreeAdapter >> selectPath: aPath [

	| items index |
	aPath ifEmpty: [ ^ widget selecter deselectAll ].

	items := widget dataSource itemsAtPath: aPath.
	index := items last position.
	
	widget selecter deselectAll; selectIndex: index
]

{ #category : #accessing }
SpToploTreeAdapter >> selectedPaths [

	^ widget selectionModel selectedIndexes collect: [ :each |
		  widget dataSource pathOfIndex: each ]
]

{ #category : #initialization }
SpToploTreeAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model
		whenSelectionChangedDo: [ self updateSelection ];
		whenRootsChangedDo: [ self updateRoots ]
]

{ #category : #initialization }
SpToploTreeAdapter >> subscribeToWidget [

	super subscribeToWidget.

	widget
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [ :evt | self transferSelectionChange: evt ].

	widget
		addEventHandlerOn: ToListStrongSelectionEvent
		do: [ :evt | self transferStrongSelection: evt ]
]

{ #category : #private }
SpToploTreeAdapter >> suspendSelectionDuring: aBlock [

	suspendTransferSelection := true.
	aBlock ensure: [ suspendTransferSelection := false ]
]

{ #category : #initialization }
SpToploTreeAdapter >> transferSelectionChange: evt [

	| currentPaths |
	currentPaths := self selectedPaths.

	currentPaths = model selection selectedPaths ifTrue: [ ^ self ].

	model selection
		clearSelection;
		selectPaths: currentPaths
]

{ #category : #initialization }
SpToploTreeAdapter >> transferStrongSelection: evt [

	model doActivateAtPath: model selection selectedPath.
]

{ #category : #initialization }
SpToploTreeAdapter >> updateAll [

	super updateAll.

	self
		updateRoots;
		updateSelection";
		updateMenu"
]

{ #category : #'updating widget' }
SpToploTreeAdapter >> updateRoots [

	widget dataAccessor
		removeAll;
		addAll: model roots
]

{ #category : #selection }
SpToploTreeAdapter >> updateSelection [

	self suspendSelectionDuring: [
		widget selecter deselectAll.
		model selection selectedPaths do: [ :each | self selectPath: each ] ]
]
