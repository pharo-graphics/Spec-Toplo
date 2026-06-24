"
I'm a Spec adapter for `SpTreePresenter`.
"
Class {
	#name : #SpToploTreeAdapter,
	#superclass : #SpToploWidgetAdapter,
	#traits : 'SpToploTTreeHelper + SpToploTWithEmbeddedListItem',
	#classTraits : 'SpToploTTreeHelper classTrait + SpToploTWithEmbeddedListItem classTrait',
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTreeAdapter >> buildWidget [

	| tree |
	tree := ToTreeElement new.
	tree useScrollbar: true.
	"tree withRowNumbers. USEFUL TO DEBUG"

	tree selecter multiple: self model selectionMode isMultipleSelection.
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

{ #category : #initialization }
SpToploTreeAdapter >> initialize [

	super initialize.
	suspendUpdateSelection := false
]

{ #category : #testing }
SpToploTreeAdapter >> isExpanded: item [

	^ widget dataSource collection
		detect: [ :each | each dataItem = item ]
		ifFound: [ :dataItem | dataItem isExpanded ]
		ifNone: [ false ]
]

{ #category : #private }
SpToploTreeAdapter >> itemAtPath: aPath [

	^ (widget dataSource itemsAtPath: aPath) last dataItem
]

{ #category : #factory }
SpToploTreeAdapter >> newItemElementFor: item [

	| labeledIcon |
	labeledIcon := ToLabeledIcon new
		               startInterspace: 10;
		               hMatchParent;
		               yourself.
	labeledIcon labelText: (model display cull: item) asRopedText.
	model displayIcon ifNotNil: [
		labeledIcon iconImage: (model displayIcon cull: item) ].

	model displayColor ifNotNil: [ :block |
			(block cull: item) ifNotNil: [ :aColor |
				labeledIcon addTokenNamed: #'color-text' withValue: aColor ] ].

	model displayItalic ifNotNil: [ :block |
		(block cull: item) ifTrue: [ labeledIcon label italic ] ].

	^ labeledIcon
]

{ #category : #accessing }
SpToploTreeAdapter >> scrollToSelection [

	self flag: #toImplement
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

{ #category : #initialization }
SpToploTreeAdapter >> transferStrongSelection: evt [

	model doActivateAtPath: model selection selectedPath.
]

{ #category : #initialization }
SpToploTreeAdapter >> treeWidget [

	^ self widget
]

{ #category : #initialization }
SpToploTreeAdapter >> updateAll [

	super updateAll.

	self
		updateRoots;
		updateSelection
]

{ #category : #'updating widget' }
SpToploTreeAdapter >> updateRoots [

	widget dataAccessor
		removeAll;
		addAll: model roots
]

{ #category : #selection }
SpToploTreeAdapter >> updateSelection [

	suspendUpdateSelection ifTrue: [ ^ self ].

	widget selecter deselectAll.
	model selection selectedPaths do: [ :each | self selectPath: each ]
]

{ #category : #'updating widget' }
SpToploTreeAdapter >> updateSelectionMode [

	widget ifNil: [ ^ self ].
	widget selecter multiple:
		self model selectionMode isMultipleSelection
]
