"
The `activatedList` keep a trace of the selected index to correctly deactivate them when items are unselected
"
Class {
	#name : #SpToploTableAdapter,
	#superclass : #SpToploAbstractListAdapter,
	#instVars : [
		'additionnalActivationBlocks',
		'additionnalDeactivationBlocks',
		'activatedList'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTableAdapter >> buildColumns [

	^ self model columns collect: [ :spCollumn |
		  self buildToploColumnFrom: spCollumn ]
]

{ #category : #factory }
SpToploTableAdapter >> buildGenericToTableColumnFrom: spCollumn [

	| column |
	column := ToTableColumn new
		          title: spCollumn title;
		          key: spCollumn title;
		          "Use yourself by default. It sometimes happen when user give a list of string as data"
		          dataIndex: (spCollumn evaluation ifNil: [ #yourself ]);
		          yourself.
	column width: spCollumn width.
	column resizable: spCollumn isExpandable.
	spCollumn isSortable ifTrue: [
		column sorterBlock: spCollumn sortFunction ].
	^ column
]

{ #category : #factory }
SpToploTableAdapter >> buildToploColumnFrom: spCollumn [

	^ spCollumn acceptColumnVisitor: self
]

{ #category : #factory }
SpToploTableAdapter >> buildWidget [

	widget := ToTableElement new.
	widget showHeader: self model isShowingColumnHeaders.
	widget selecter multiple: self model selectionMode isMultipleSelection.
	widget columns: self buildColumns.
	^ widget
]

{ #category : #initialization }
SpToploTableAdapter >> initialize [

	super initialize.
	additionnalActivationBlocks := OrderedCollection new.
	additionnalDeactivationBlocks := OrderedCollection new.
	activatedList := Set new
]

{ #category : #initialization }
SpToploTableAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenSelectionChangedDo: [ :selection |
			selection selectedIndex > 0 ifTrue: [
					additionnalActivationBlocks do: [ :block |
							block value: (model itemAt: selection selectedIndex).
							activatedList add: selection selectedIndex ] ].
			selection selectedIndex = 0 ifTrue: [ "deactivation context"
					activatedList do: [ :idx |
							additionnalDeactivationBlocks do: [ :block |
								block value: (model itemAt: idx) ] ].
					activatedList removeAll ] ]
]

{ #category : #initialization }
SpToploTableAdapter >> subscribeToWidget [

	super subscribeToWidget.

	widget list
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [ :event |
			model selection selectIndexes: widget list selecter selectedIndexes ];
		addEventHandlerOn: ToListStrongSelectionEvent
		do: [ model doActivateAtIndex: model selection selectedIndex ]
]

{ #category : #protocol }
SpToploTableAdapter >> takeKeyboardFocus [
	self flag: #toImplement
]

{ #category : #visiting }
SpToploTableAdapter >> visitCheckboxColumn: aSpCheckBoxTableColumn [

	| column |
	column := self buildGenericToTableColumnFrom: aSpCheckBoxTableColumn.
	column cellBuilder: [ :element :dataItem :holder |
			| checkbox |
			checkbox := ToCheckbox new.
			checkbox addEventHandlerOn: ToCheckableCheckEvent do: [ :event |
					event checked
						ifTrue: [ aSpCheckBoxTableColumn onActivation value: holder dataItem ]
						ifFalse: [ aSpCheckBoxTableColumn onDeactivation value: holder dataItem ] ].
			element addChild: checkbox ].

	^ column
]

{ #category : #visitor }
SpToploTableAdapter >> visitCompositeColumn: spCollumn [

	| column |
	"In this case, consider that the table has a column with checkbox for selection"
	column := self buildGenericToTableColumnFrom: spCollumn.
	"Use yourself by default. It sometimes happen when user give a list of string as data"
	(spCollumn columns first isKindOf: SpCheckBoxTableColumn)
		ifTrue: [
				widget useCheckbox: true.
				spCollumn columns first onActivation ifNotNil: [ :activationBlock |
					additionnalActivationBlocks add: activationBlock ].
				spCollumn columns first onDeactivation ifNotNil: [
					:deactivationBlock |
					additionnalDeactivationBlocks add: deactivationBlock ] ]
		ifFalse: [
				column cellBuilder: [ :element :dataItem :holder |
						| pane |
						pane := ToElement new
							        layout: BlLinearLayout horizontal;
							        fitContent;
							        yourself.
						spCollumn columns do: [ :innerColumn |
								(innerColumn acceptColumnVisitor: self) cellBuilder
									value: pane
									value: dataItem
									value: holder ].
						element addChild: pane ] ].

	^ column
]

{ #category : #visiting }
SpToploTableAdapter >> visitImageColumn: aSpImageTableColumn [

	| column |
	column := self buildGenericToTableColumnFrom: aSpImageTableColumn.
	column cellBuilder: [ :element :dataItem :holder |
			(aSpImageTableColumn readObject: holder dataItem) ifNotNil: [ :icon |
				element addChild: icon asForm asElement ] ].

	^ column
]

{ #category : #visitor }
SpToploTableAdapter >> visitStringColumn: spCollumn [

	| column |
	column := self buildGenericToTableColumnFrom: spCollumn.
	column cellBuilder: [ :element :dataItem :holder |
			| label skin |
			label := spCollumn evaluation
				         ifNil: [ ToLabel text: dataItem asString ]
				         ifNotNil: [ :evalBlock |
				         ToLabel text: (evalBlock value: holder dataItem) ].
			skin := SpToploTableColumnSkin new.
			label defaultSkin: skin.
			spCollumn displayColor ifNotNil: [ :displayColorBlock |
				skin foreground: (displayColorBlock value: holder dataItem) ].

			spCollumn displayItalic ifNotNil: [ :displayItalicBlock |
				(displayItalicBlock value: holder dataItem) ifTrue: [
					skin italic: true ] ].

			spCollumn displayBold ifNotNil: [ :displayBoldBlock |
				(displayBoldBlock value: holder dataItem) ifTrue: [ skin bold: true ] ].
			element addChild: label ].
	^ column
]
