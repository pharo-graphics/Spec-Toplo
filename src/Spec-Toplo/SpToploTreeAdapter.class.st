Class {
	#name : #SpToploTreeAdapter,
	#superclass : #SpToploWidgetAdapter,
	#instVars : [
		'suspendTransferSelection'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #initialization }
SpToploTreeAdapter >> basicSelectionChanged: ann [
	1halt.
	"| selection |

	selection := self presenter selection.
	ann newSelectedIndexes ifEmpty: [ ^ selection unselectAll ].
	(ann newSelectedIndexes difference: ann oldSelectedIndexes) ifEmpty: [ ^ self ].

	selection selectPaths: (ann newSelectedIndexes
		collect: [ :index | self widget dataSource pathFromIndex: index ]).

	self presenter isActiveOnSingleClick ifTrue: [
		self presenter doActivateAtPath: selection selectedPath ]"
]

{ #category : #factory }
SpToploTreeAdapter >> buildWidget [

	| tree |
	tree := ToTreeElement new.

	tree nodeManager childrenGetter: [ :dataItem |
		model childrenFor: dataItem ].
	
	tree nodeBuilder: [ :node :dataItem :holder |
		node addChild: (self newItemElementFor: dataItem) ].

	^ tree
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

	| items |
	aPath ifEmpty: [ ^ widget selecter deselectAll ].

	items := widget dataSource itemsAtPath: aPath.

	widget selecter selectIndex: items last position
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

{ #category : #'as yet unclassified' }
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

	1halt.
	model doActivateAtPath: 1halt. "model selection selectedIndex"
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
