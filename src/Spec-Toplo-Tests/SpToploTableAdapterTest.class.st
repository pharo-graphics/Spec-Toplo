"
A SpToploTableAdapterTest is a test class for testing the behavior of SpToploTableAdapter
"
Class {
	#name : #SpToploTableAdapterTest,
	#superclass : #SpToploAbstractAdapterTest,
	#instVars : [
		'chooser',
		'tablePresenter'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #'test - building' }
SpToploTableAdapterTest >> buildChooserPresenter [

	chooser := SpChooserPresenter
		           sourceItems: {
				           SpChooserPresenter.
				           SpFilteringListPresenter }
		           chosenItems: { SpFilteringSelectableListPresenter }
		           displayBlock: #name.
	chooser application: application.
	^ chooser build
]

{ #category : #'test - building' }
SpToploTableAdapterTest >> buildTablePresenter [

	| column |
	column := SpStringTableColumn new
		          title: 'Title';
		          yourself.

	tablePresenter := SpTablePresenter new
		                  items: { #right. #center. #left };
		                  addColumn: column.
	tablePresenter application: application.
	^ tablePresenter build
]

{ #category : #'test - building' }
SpToploTableAdapterTest >> buildThreeColumnTablePresenter [

	| presenter |
	presenter := SpTablePresenter new.
	presenter application: application.
	presenter items: { 'first'. 'second' }.
	presenter addColumn: (SpStringTableColumn new
		 title: 'Repositories';
		 width: 200;
		 yourself).
	presenter addColumn: (SpStringTableColumn new
		 title: 'Status';
		 width: 200;
		 yourself).
	presenter addColumn: (SpStringTableColumn new
		 title: 'Hash';
		 yourself).
	^ presenter
]

{ #category : #chooser }
SpToploTableAdapterTest >> dataSourceOfChooserList: aChooserList [

	^ (((aChooserList listPresenter adapter widget childWithId: #singleChild) childAt: 1) childAt: 2) dataSource
]

{ #category : #chooser }
SpToploTableAdapterTest >> testChooserSelectAll [

	self buildChooserPresenter.
	self assert: (self dataSourceOfChooserList: chooser targetList) itemCount equals: 1.
	self assert: (self dataSourceOfChooserList: chooser sourceList) itemCount equals: 2.
	chooser sourceList selectItem: SpChooserPresenter.
	chooser sourceList selectItem: SpFilteringListPresenter.
	chooser addSelected.
	self assert: (self dataSourceOfChooserList: chooser sourceList) itemCount equals: 0.
	self assert: (self dataSourceOfChooserList: chooser targetList) itemCount equals: 3
]

{ #category : #chooser }
SpToploTableAdapterTest >> testChooserSelection [

	self buildChooserPresenter.
	self assert: (self dataSourceOfChooserList: chooser targetList) itemCount equals: 1.
	self assert: (self dataSourceOfChooserList: chooser sourceList) itemCount equals: 2.
	chooser sourceList selectItem: SpChooserPresenter.
	chooser addSelected.
	self assert: (self dataSourceOfChooserList: chooser sourceList) itemCount equals: 1.
	self assert: (self dataSourceOfChooserList: chooser targetList) itemCount equals: 2
]

{ #category : #tests }
SpToploTableAdapterTest >> testColumnStateWidthsMatchSpecColumnWidthsAfterSwitchingNotebookPage [

	| notebook firstTable secondTable |
	firstTable := self buildThreeColumnTablePresenter.
	secondTable := self buildThreeColumnTablePresenter.
	notebook := SpNotebookPresenter new.
	notebook application: application.
	notebook addPageTitle: 'First' provider: [ firstTable ].
	notebook addPageTitle: 'Second' provider: [ secondTable ].
	notebook open.
	notebook selectPageIndex: 2.
	notebook adapter widget space settle.
	self assert: (secondTable adapter widget columnStateAt: 1) width equals: 200.
	self assert: (secondTable adapter widget columnStateAt: 2) width equals: 200
]

{ #category : #tests }
SpToploTableAdapterTest >> testColumnsStayVisibleWhenSwitchingNotebookPages [

	| notebook firstTable secondTable headerWidths |
	firstTable := self buildThreeColumnTablePresenter.
	secondTable := self buildThreeColumnTablePresenter.
	notebook := SpNotebookPresenter new.
	notebook application: application.
	notebook addPageTitle: 'First' provider: [ firstTable ].
	notebook addPageTitle: 'Second' provider: [ secondTable ].
	notebook open.
	notebook selectPageIndex: 2.
	notebook adapter widget space settle.
	headerWidths := OrderedCollection new.
	secondTable adapter widget allChildrenBreadthFirstDo: [ :each | each class == ToTableHeaderCell ifTrue: [ headerWidths add: each bounds asRectangle width ] ].
	self assert: headerWidths size equals: 3.
	self assert: (headerWidths allSatisfy: [ :width | width > 20 ])
]

{ #category : #tests }
SpToploTableAdapterTest >> testContextMenuWithActions [

	| group contextMenu |
	self buildTablePresenter.
	group := SpActionGroup new.
	group addActionWith: [ :action |
		action
			name: 'TestCommand';
			action: [ ] ].
	tablePresenter actions: group.

	contextMenu := ToContextMenu new.
	tablePresenter adapter fillContextMenu: contextMenu.

	self assert: contextMenu items size equals: 1.
	self assert: contextMenu items first label text asString equals: 'TestCommand'
]

{ #category : #tests }
SpToploTableAdapterTest >> testContextMenuWithDisabledAction [

	| group contextMenu |
	self buildTablePresenter.
	group := SpActionGroup new.
	group addActionWith: [ :action |
		action
			name: 'DisabledCommand';
			actionEnabled: [ false ];
			action: [ ] ].
	tablePresenter actions: group.

	contextMenu := ToContextMenu new.
	tablePresenter adapter fillContextMenu: contextMenu.

	self assert: contextMenu items size equals: 1.
	self deny: contextMenu items first isEnabled
]

{ #category : #chooser }
SpToploTableAdapterTest >> testTableColumnsNumber [

	self buildTablePresenter.
	"If I select and unslect. No move should happen"
	self
		assert: tablePresenter adapter widget list columns size
		equals: 1
]

{ #category : #chooser }
SpToploTableAdapterTest >> testTableSelectionMultiSelection [

	self buildTablePresenter.
	tablePresenter beMultipleSelection.
	"If I select and unslect. No move should happen"
	tablePresenter adapter widget list selecter selectIndex: 1.
	self assert: tablePresenter selectedIndex equals: 1.
	tablePresenter selectIndex: 2.
	"no api for selected indexes"
	self assert: tablePresenter selectedItems size equals: 2.
	self
		assert: tablePresenter adapter widget list selecter selectedIndexes
		equals: #(1 2)
]

{ #category : #chooser }
SpToploTableAdapterTest >> testTableSelectionSingleSelection [

	self buildTablePresenter.
	tablePresenter beSingleSelection.
	"If I select and unslect. No move should happen"
	tablePresenter adapter widget list selecter selectIndex: 1.
	self assert: tablePresenter selectedIndex equals: 1.
	tablePresenter selectIndex: 2.
	self assert: tablePresenter selectedIndex equals: 2.
	self
		assert: tablePresenter adapter widget list selecter selectedIndex
		equals: 2
]
