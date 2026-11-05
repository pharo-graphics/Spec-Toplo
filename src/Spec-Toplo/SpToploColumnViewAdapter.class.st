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

	^ self model columns collect: [ :aSpTableColumn |
		self buildToploColumnFrom: aSpTableColumn ]
]

{ #category : #factory }
SpToploColumnViewAdapter >> buildGenericToTableColumnFrom: aSpTableColumn [

	| column |
	column := ToTableColumn new.
	column
		title: aSpTableColumn title;
		key: aSpTableColumn title;
		"Use yourself by default. It sometimes happen when user give a list of string as data"
		yourself.
	(aSpTableColumn respondsTo: #evaluation)
		ifTrue: [ "check from Pharo 13 and inferior"
			column dataIndex: (aSpTableColumn evaluation ifNil: [ #yourself ]) ]
		ifFalse: [
			column dataIndex: #yourself ].
	column width: aSpTableColumn width.
	column resizable: aSpTableColumn isExpandable.
	"A string column derives its default sort function from its evaluation, so it cannot provide one without it"
	(aSpTableColumn isSortable and: [ (aSpTableColumn isKindOf: SpStringTableColumn) not or: [ aSpTableColumn evaluation isNotNil ] ]) ifTrue: [
		| sortFunction |
		sortFunction := aSpTableColumn sortFunction.
		sortFunction ifNotNil: [ :existingSortFunction |
			column sorterBlock: existingSortFunction ] ].
	^ column
]

{ #category : #factory }
SpToploColumnViewAdapter >> buildToploColumnFrom: aSpTableColumn [

	^ aSpTableColumn acceptColumnVisitor: self
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

{ #category : #accessing }
SpToploColumnViewAdapter >> firstRowNode [
	"Answer the node of the first row of the adapted table. A ToTableElement holds its rows in its inner list element."

	^ self widget list nodes first
]

{ #category : #testing }
SpToploColumnViewAdapter >> hasHeader [

	^ self isShowColumnHeaders
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
		do: [ :event | model selection selectIndexes: widget list selecter selectedIndexes ];
		addEventHandlerOn: BlPrimaryClickEvent do: [ :evt | self transferClick: evt ];
		addEventHandlerOn: ToListStrongSelectionEvent
		do: [ model isActiveOnDoubleClick ifTrue: [ model doActivateAtIndex: model selection selectedIndex ] ]
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
			element hMatchParent.
			element vFitContent.
			pane := ToElement new
				        layout: BlLinearLayout horizontal;
				        yourself.
			pane hMatchParent.
			pane vFitContent.
			

			contentPresenter := spCollumn setupAction value: self model.
			spCollumn bindAction value: contentPresenter value: dataItem.

			toElement := contentPresenter build.
			toElement userData at: #specModel put: dataItem.
			toElement fitContent.
			self prepareEmbeddedItemPanesIn: toElement.
			toElement hMatchParent.
			toElement vFitContent.

			pane addChild: toElement.
			element addChild: pane ].
	column width: spCollumn width.
	column resizable: spCollumn isExpandable.
	spCollumn isSortable ifTrue: [ column sorterBlock: spCollumn sortFunction ].
	^ column
]

{ #category : #visitor }
SpToploColumnViewAdapter >> visitCompositeColumn: aSpTableColumn [

	| column |
	column := self buildGenericToTableColumnFrom: aSpTableColumn.
	(aSpTableColumn columns isNotEmpty and: [
		 aSpTableColumn columns first isKindOf: SpCheckBoxTableColumn ])
		ifTrue: [
			widget useCheckbox: true.
			aSpTableColumn columns first onActivation ifNotNil: [ :activationBlock |
				additionnalActivationBlocks add: activationBlock ].
			aSpTableColumn columns first onDeactivation ifNotNil: [ :deactivationBlock |
				additionnalDeactivationBlocks add: deactivationBlock ] ]
		ifFalse: [
			column cellBuilder: [ :element :dataItem :holder |
				| pane |
				pane := ToElement new.
				pane
					layout: BlLinearLayout horizontal;
					fitContent.
				aSpTableColumn columns do: [ :innerColumn |
					(innerColumn acceptColumnVisitor: self) cellBuilder
						value: pane
						value: dataItem
						value: holder ].
				element addChild: pane ] ].
	^ column
]

{ #category : #visitor }
SpToploColumnViewAdapter >> visitImageColumn: aSpImageTableColumn [

	| column |
	column := self buildGenericToTableColumnFrom: aSpImageTableColumn.
	column cellBuilder: [ :element :dataItem :holder |
		(aSpImageTableColumn readObject: holder dataItem) ifNotNil: [ :icon |
			element addChild: icon asForm asElement ] ].
	^ column
]

{ #category : #visiting }
SpToploColumnViewAdapter >> visitLinkColumn: aSpTableColumn [

	| column |
	column := self buildGenericToTableColumnFrom: aSpTableColumn.
	column cellBuilder: [ :element :dataItem :holder |
		| label |
		aSpTableColumn evaluation
			ifNil: [ label := ToLabel text: dataItem asString ]
			ifNotNil: [ :evalBlock |
				label := ToLabel text: (evalBlock value: holder dataItem) ].
		label clickAction: aSpTableColumn action.
		label addTokenNamed: #'color-text' withValue: self theme urlColor.
		element addChild: label ].
	^ column
]

{ #category : #visitor }
SpToploColumnViewAdapter >> visitStringColumn: aSpTableColumn [

	| column |
	column := self buildGenericToTableColumnFrom: aSpTableColumn.
	column cellBuilder: [ :element :dataItem :holder |
		| label skin |
		aSpTableColumn evaluation
			ifNil: [ label := ToLabel text: dataItem asString ]
			ifNotNil: [ :evalBlock |
				label := ToLabel text: (evalBlock value: holder dataItem) ].
		skin := SpToploTableColumnSkin new.
		label defaultSkin: skin.
		aSpTableColumn displayColor ifNotNil: [ :displayColorBlock |
			skin foreground: (displayColorBlock value: holder dataItem) ].
		aSpTableColumn displayItalic ifNotNil: [ :displayItalicBlock |
			(displayItalicBlock value: holder dataItem) ifTrue: [
				skin italic: true ] ].
		aSpTableColumn displayBold ifNotNil: [ :displayBoldBlock |
			(displayBoldBlock value: holder dataItem) ifTrue: [
				skin bold: true ] ].
		element addChild: label ].
	^ column
]
