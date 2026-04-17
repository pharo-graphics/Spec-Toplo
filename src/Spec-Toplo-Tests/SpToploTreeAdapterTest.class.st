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

{ #category : #'test - building' }
SpToploTreeAdapterTest >> buildTreePresenter [

	treePresenter := SpTreePresenter new
		                 roots: { #rootA. #rootB };
		                 children: [ :item | #(  ) ].
	treePresenter application: application.
	^ treePresenter build
]

{ #category : #'test - building' }
SpToploTreeAdapterTest >> buildTreeTablePresenter [

	| column |
	column := SpStringTableColumn new
		          title: 'Name';
		          yourself.

	treeTablePresenter := SpTreeTablePresenter new
		                      roots: { #rootA. #rootB };
		                      children: [ :item | #(  ) ];
		                      addColumn: column.
	treeTablePresenter application: application.
	^ treeTablePresenter build
]

{ #category : #running }
SpToploTreeAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #tests }
SpToploTreeAdapterTest >> testTreeCanBeBuiltInMultipleSelectionMode [

	treePresenter := SpTreePresenter new
		                 roots: { #rootA. #rootB };
		                 children: [ :item | #(  ) ];
		                 beMultipleSelection.
	treePresenter application: application.
	treePresenter build.

	self assert:
		treePresenter adapter widget selecter isMultipleSelection
]

{ #category : #tests }
SpToploTreeAdapterTest >> testTreeStartsInSingleSelectionMode [

	self buildTreePresenter.

	self assert: treePresenter adapter widget selecter isSingleSelection
]

{ #category : #tests }
SpToploTreeAdapterTest >> testTreeTableSelectionUpdateReplacesPreviousIndexes [

	| column |
	column := SpStringTableColumn new
		          title: 'Name';
		          yourself.

	treeTablePresenter := SpTreeTablePresenter new
		                      roots: { #rootA. #rootB };
		                      children: [ :item | #(  ) ];
		                      addColumn: column;
		                      beMultipleSelection.
	treeTablePresenter application: application.
	treeTablePresenter build.

	treeTablePresenter selectPaths: {
			#( 1 ).
			#( 2 ) }.
	self
		assert:
		treeTablePresenter adapter treeWidget selecter selectedIndexes
		equals: #( 1 2 ).

	treeTablePresenter selection
		clearSelection;
		selectPaths: { #( 1 ) }.

	self
		assert:
		treeTablePresenter adapter treeWidget selecter selectedIndexes
		equals: #( 1 )
]
