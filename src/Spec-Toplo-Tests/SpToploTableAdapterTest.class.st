"
A SpToploTableAdapterTest is a test class for testing the behavior of SpToploTableAdapter
"
Class {
	#name : #SpToploTableAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
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

{ #category : #running }
SpToploTableAdapterTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #chooser }
SpToploTableAdapterTest >> testChooserSelectAll [

	self buildChooserPresenter.
	self
		assert:
		chooser targetList listPresenter adapter widget list itemCount
		equals: 1.
	self
		assert:
		chooser sourceList listPresenter adapter widget list itemCount
		equals: 2.
	chooser sourceList listPresenter selectIndex: 1.
	chooser sourceList listPresenter selectIndex: 2.
	chooser addSelected.
	self
		assert:
		chooser sourceList listPresenter adapter widget list itemCount
		equals: 0.
	self
		assert:
		chooser targetList listPresenter adapter widget list itemCount
		equals: 3
]

{ #category : #chooser }
SpToploTableAdapterTest >> testChooserSelectAndUnselectSameItem [

	self buildChooserPresenter.
	"If I select and unslect. No move should happen"
	chooser sourceList listPresenter selectIndex: 1.
	chooser sourceList listPresenter unselectIndex: 1.
	chooser addSelected.
	self
		assert:
		chooser sourceList listPresenter adapter widget list itemCount
		equals: 2.
	self
		assert:
		chooser targetList listPresenter adapter widget list itemCount
		equals: 1
]

{ #category : #chooser }
SpToploTableAdapterTest >> testChooserSelection [

	self buildChooserPresenter.
	self
		assert:
		chooser targetList listPresenter adapter widget list itemCount
		equals: 1.
	self
		assert:
		chooser sourceList listPresenter adapter widget list itemCount
		equals: 2.
	chooser sourceList listPresenter selectIndex: 1.
	chooser addSelected.
	self
		assert:
		chooser sourceList listPresenter adapter widget list itemCount
		equals: 1.
	self
		assert:
		chooser targetList listPresenter adapter widget list itemCount
		equals: 2
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
