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

{ #category : #'as yet unclassified' }
SpToploTableAdapter >> buildGenericToTableColumnFrom: spCollumn [

	| column |
	column := ToTableColumn new
		  title: spCollumn title;
		  key: spCollumn title;
		  "Use yourself by default. It sometimes happen when user give a list of string as data"
		  dataIndex: (spCollumn evaluation ifNil: [ #yourself ]);
		  yourself.
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
			model selection selectIndexes: widget list selecter selectedIndexes.
			  ];
		addEventHandlerOn: ToListStrongSelectionEvent
		do: [ model doActivateAtIndex: model selection selectedIndex ]
]

{ #category : #visitor }
SpToploTableAdapter >> visitCompositeColumn: spCollumn [

	| column |
	"In this case, consider that the table has a column with checkbox for selection"
	column := self buildGenericToTableColumnFrom: spCollumn.
	"Use yourself by default. It sometimes happen when user give a list of string as data"
	(spCollumn columns first isKindOf: SpCheckBoxTableColumn) ifTrue: [
			widget useCheckbox: true.
			spCollumn columns first onActivation ifNotNil: [ :activationBlock |
				additionnalActivationBlocks add: activationBlock ].
			spCollumn columns first onDeactivation ifNotNil: [
				:deactivationBlock |
				additionnalDeactivationBlocks add: deactivationBlock ] ].

	^ column
]

{ #category : #visiting }
SpToploTableAdapter >> visitImageColumn: aSpImageTableColumn [

	| column |
	column := self buildGenericToTableColumnFrom: aSpImageTableColumn.
	column cellBuilder: [ :element :dataItem :holder |
		element addChild: dataItem asElement ].

	^ column
]

{ #category : #visitor }
SpToploTableAdapter >> visitStringColumn: spCollumn [

	| column |
	column := self buildGenericToTableColumnFrom: spCollumn.
	column cellBuilder: [ :element :dataItem :holder |
			| label |
			label := ToAttributedLabel text: dataItem asString.
			spCollumn displayColor ifNotNil: [ :displayColorBlock |
				label foreground: (displayColorBlock value: holder dataItem) ].

			spCollumn displayItalic ifNotNil: [ :displayItalicBlock |
				(displayItalicBlock value: holder dataItem) ifTrue: [
					label italic ] ].

			spCollumn displayBold ifNotNil: [ :displayBoldBlock |
				(displayBoldBlock value: holder dataItem) ifTrue: [ label bold ] ].

			element addChild: label ].
	^ column
]
