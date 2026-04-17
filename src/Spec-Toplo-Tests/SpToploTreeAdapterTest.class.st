Class {
	#name : #SpToploTreeAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'treePresenter',
		'treeTablePresenter'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #running }
SpToploTreeAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #tests }
SpToploTreeAdapterTest >> testTreeStartsInSingleSelectionMode [

	self buildTreePresenter.

	self assert: treePresenter adapter widget selecter isSingleSelection
]
