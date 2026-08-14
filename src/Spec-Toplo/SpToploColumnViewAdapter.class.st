"
The `activatedList` keep a trace of the selected index to correctly deactivate them when items are unselected
"
Class {
	#name : #SpToploColumnViewAdapter,
	#superclass : #SpToploAbstractListAdapter,
	#instVars : [
		'additionnalActivationBlocks',
		'additionnalDeactivationBlocks',
		'activatedList'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #api }
SpToploColumnViewAdapter >> alternateRowsColor [

	self flag: #shouldWeKeepThis
]

{ #category : #factory }
SpToploColumnViewAdapter >> buildColumns [

	^ self model columns collect: [ :spCollumn |
		  self buildToploColumnFrom: spCollumn ]
]

{ #category : #factory }
SpToploColumnViewAdapter >> buildGenericToTableColumnFrom: spCollumn [

	| column |
	column := ToTableColumn new
		          title: spCollumn title;
		          key: spCollumn title;
		          "Use yourself by default. It sometimes happen when user give a list of string as data"yourself.
	(spCollumn respondsTo: #evaluation)
		ifTrue: [ "check from Pharo 13 and inferior" column dataIndex: (spCollumn evaluation ifNil: [ #yourself ]) ]
		ifFalse: [ column dataIndex: #yourself ].
	column width: spCollumn width.
	column resizable: spCollumn isExpandable.
	spCollumn isSortable ifTrue: [ column sorterBlock: spCollumn sortFunction ].
	^ column
]

{ #category : #factory }
SpToploColumnViewAdapter >> buildToploColumnFrom: spCollumn [

	^ spCollumn acceptColumnVisitor: self
]

{ #category : #factory }
SpToploColumnViewAdapter >> buildWidget [

	widget := ToTableElement new.
	widget showHeader: self model isShowingColumnHeaders.
	widget selecter multiple: self model selectionMode isMultipleSelection.
	widget columns: self buildColumns.
	^ widget
]

{ #category : #accessing }
SpToploColumnViewAdapter >> columns [

	^ self widget columns
]

{ #category : #initialization }
SpToploColumnViewAdapter >> initialize [

	super initialize.
	additionnalActivationBlocks := OrderedCollection new.
	additionnalDeactivationBlocks := OrderedCollection new.
	activatedList := Set new
]

{ #category : #testing }
SpToploColumnViewAdapter >> isShowColumnHeaders [
	
	^ self widget showHeader
]

{ #category : #initialization }
SpToploColumnViewAdapter >> subscribeToPresenter [

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
SpToploColumnViewAdapter >> subscribeToWidget [

	widget list
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [ :event |
			model selection selectIndexes: widget list selecter selectedIndexes ];
		addEventHandlerOn: ToListStrongSelectionEvent
		do: [ model doActivateAtIndex: model selection selectedIndex ]
]

{ #category : #protocol }
SpToploColumnViewAdapter >> takeKeyboardFocus [
	self flag: #toImplement
]

{ #category : #enumerating }
SpToploColumnViewAdapter >> traversePresentersDo: aFullBlockClosure excluding: aCollection [ 
	self flag: #todo
]

{ #category : #visiting }
SpToploColumnViewAdapter >> visitCheckboxColumn: aSpCheckBoxTableColumn [

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

{ #category : #visiting }
SpToploColumnViewAdapter >> visitColumnViewColumn: spCollumn [

	| column |
	column := self buildGenericToTableColumnFrom: spCollumn.
	"Use yourself by default. It sometimes happen when user give a list of string as data"
	"dataIndex: [:val | spCollumn bindAction value: self model value: val ];"
	column cellBuilder: [ :element :dataItem :holder |
			| pane contentPresenter toElement |
			element fitContent.
			pane := ToElement new
				        layout: BlLinearLayout horizontal;
				        fitContent;
				        yourself.

			contentPresenter := spCollumn setupAction value: self model.
			spCollumn bindAction value: contentPresenter value: dataItem.

			toElement := contentPresenter build.
			toElement userData at: #specModel put: dataItem.

			self prepareEmbeddedItemPanesIn: toElement.
			pane addChild: toElement.
			element addChild: pane ].
	column width: spCollumn width.
	column resizable: spCollumn isExpandable.
	spCollumn isSortable ifTrue: [ column sorterBlock: spCollumn sortFunction ].
	^ column
]

{ #category : #visitor }
SpToploColumnViewAdapter >> visitCompositeColumn: spCollumn [

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
SpToploColumnViewAdapter >> visitImageColumn: aSpImageTableColumn [

	| column |
	column := self buildGenericToTableColumnFrom: aSpImageTableColumn.
	column cellBuilder: [ :element :dataItem :holder |
			(aSpImageTableColumn readObject: holder dataItem) ifNotNil: [ :icon |
				element addChild: icon asForm asElement ] ].

	^ column
]

{ #category : #visiting }
SpToploColumnViewAdapter >> visitLinkColumn: spCollumn [

	| column |
	column := self buildGenericToTableColumnFrom: spCollumn.
	column cellBuilder: [ :element :dataItem :holder |
			| label skin |
			label := spCollumn evaluation
				         ifNil: [ ToLabel text: dataItem asString ]
				         ifNotNil: [ :evalBlock |
				         ToLabel text: (evalBlock value: holder dataItem) ].
			label clickAction: spCollumn action.
			label addTokenNamed: #'color-text' withValue: self theme urlColor.
			element addChild: label ].
	^ column
]

{ #category : #visitor }
SpToploColumnViewAdapter >> visitStringColumn: spCollumn [

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
