"
A SpToploTableAdapterTest is a test class for testing the behavior of SpToploTableAdapter
"
Class {
	#name : #SpToploTableAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'chooser'
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
	chooser sourceList listPresenter selectIndex: 1.
	chooser sourceList listPresenter unselectIndex: 1.
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
