Class {
	#name : #SpToploListAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
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

{ #category : #running }
SpToploListAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #running }
SpToploListAdapterTest >> tearDown [

	application ifNotNil: [
		application windows do: [ :each | each delete ] ].
	super tearDown
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

{ #category : #running }
SpToploListAdapterTest >> waitUntilUIRedrawed [

	| aSpace |
	aSpace := application windows anyOne adapter widget.
	BlSpace
		pulseUntilSpaceOpenedAndEmptyTaskQueue: aSpace
		timeout: 200 milliSeconds
]
