Class {
	#name : #SpToploListAdapterTest,
	#superclass : #SpToploHeadlessTestCase,
	#instVars : [
		'listPresenter'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #'test - building' }
SpToploListAdapterTest >> buildListPresenter [

	listPresenter := SpListPresenter new items: { #a. #b. #c }.
	listPresenter application: application.
	listPresenter open.
	self waitUntilUIRedrawed.
	^ listPresenter
]

{ #category : #tests }
SpToploListAdapterTest >> testProgrammaticSelectionNotifiesOnce [

	| changes |
	self buildListPresenter.
	changes := 0.
	listPresenter whenSelectionChangedDo: [ changes := changes + 1 ].
	listPresenter selectIndex: 2.
	self waitUntilUIRedrawed.
	self assert: listPresenter selectedIndex equals: 2.
	self
		assert: listPresenter adapter widget selecter selectedIndexes
		equals: #( 2 ).
	self assert: changes equals: 1
]
