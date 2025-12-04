Class {
	#name : #SpToploTableAdapter,
	#superclass : #SpToploAbstractListAdapter,
	#instVars : [
		'additionnalActivationBlocks',
		'additionnalDeactivationBlocks',
		'table'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTableAdapter >> buildColumns [

	^ self model columns collect: [ :spCollumn |
		  self buildToploColumnFrom: spCollumn ]
]

{ #category : #factory }
SpToploTableAdapter >> buildToploColumnFrom: spCollumn [

	^ spCollumn acceptColumnVisitor: self
]

{ #category : #factory }
SpToploTableAdapter >> buildWidget [

	table := ToTableElement new.
	table showHeader: self model isShowingColumnHeaders.
	table columns: self buildColumns.
	^ table
]

{ #category : #initialization }
SpToploTableAdapter >> initialize [

	super initialize.
	additionnalActivationBlocks := OrderedCollection new.
	additionnalDeactivationBlocks := OrderedCollection new
]

{ #category : #initialization }
SpToploTableAdapter >> subscribeToWidget [

	super subscribeToWidget.

	widget list
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [ :event |
				| touchedElements additionnalBlock |
				model selection selectIndexes:
						widget list selecter selectedIndexes.
				"If their is no selectedIndexes. Probably a reset of the collection so do nothing"
				widget list selecter selectedIndexes ifNotEmpty: [
							touchedElements := event touchedIntervals flatCollect: [
									                   :intervals |
									                   intervals collect: [ :idx |
											                   event target dataAccessor at: idx ] ].

							additionnalBlock := event selectionOption triggerSelectionState
								                    ifTrue: [ additionnalActivationBlocks ]
								                    ifFalse: [ additionnalDeactivationBlocks ].
							touchedElements do: [ :el |
									additionnalBlock do: [ :block | block value: el ] ] ] ];
		addEventHandlerOn: ToListStrongSelectionEvent
		do: [ model doActivateAtIndex: model selection selectedIndex ]
]

{ #category : #visitor }
SpToploTableAdapter >> visitCompositeColumn: spCollumn [

	| column |
	"In this case, consider that the table has a column with checkbox for selection"
	column := ToTableColumn new
		          title: spCollumn title;
		          key: spCollumn title;
		          "Use yourself by default. It sometimes happen when user give a list of string as data"
		          dataIndex: (spCollumn evaluation ifNil: [ #yourself ]);
		          yourself.
	(spCollumn columns first isKindOf: SpCheckBoxTableColumn) ifTrue: [
		table useCheckbox: true.
		spCollumn columns first onActivation ifNotNil: [ :activationBlock | additionnalActivationBlocks add: activationBlock  ].
		spCollumn columns first onDeactivation ifNotNil: [ :deactivationBlock | additionnalDeactivationBlocks add: deactivationBlock  ].
		 ].
	spCollumn isSortable ifTrue: [
		column sorterBlock: spCollumn sortFunction ].
	^ column
]

{ #category : #visitor }
SpToploTableAdapter >> visitStringColumn: spCollumn [

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
