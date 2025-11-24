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

{ #category : #running }
SpToploTableAdapterTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #running }
SpToploTableAdapterTest >> testChooserSelection [

	chooser := SpChooserPresenter
		           sourceItems: {
				           SpChooserPresenter.
				           SpFilteringListPresenter }
		           chosenItems: { SpFilteringSelectableListPresenter }
		           displayBlock: #name.
	chooser application: application.
	chooser build.
	
	self assert: chooser targetList listPresenter adapter widget list itemCount equals: 1.
	self assert: chooser sourceList listPresenter adapter widget list itemCount equals: 2.
	chooser sourceList listPresenter selectIndex: 1.
	chooser addSelected.
	self assert: chooser targetList listPresenter adapter widget list itemCount equals: 2.
	self assert: chooser sourceList listPresenter adapter widget list itemCount equals: 1
]
