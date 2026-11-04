Class {
	#name : #SpToploEmbeddedListItemAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #support }
SpToploEmbeddedListItemAdapterTest >> assertAllPanesTransparentIn: anElement [

	({ ToPane. ToTableCell. ToTableCellContainer. ToTableRowNode }
		anySatisfy: [ :each | anElement isKindOf: each ])
		ifTrue: [ self assert: anElement background isTransparent ].

	anElement childrenDo: [ :child | self assertAllPanesTransparentIn: child ]
]

{ #category : #support }
SpToploEmbeddedListItemAdapterTest >> assertEmbeddedPanesTransparentInFirstNodeOf: aListElement [

	self assertAllPanesTransparentIn: aListElement nodes first children first
]

{ #category : #support }
SpToploEmbeddedListItemAdapterTest >> bindNestedRowPresenter: aRowPresenter to: anItem [

	aRowPresenter layout children first layout children first label: anItem asString
]

{ #category : #support }
SpToploEmbeddedListItemAdapterTest >> firstDescendantOfClass: aClass in: anElement [

	(anElement isKindOf: aClass) ifTrue: [ ^ anElement ].
	anElement childrenDo: [ :child | (self firstDescendantOfClass: aClass in: child) ifNotNil: [ :found | ^ found ] ].
	^ nil
]

{ #category : #support }
SpToploEmbeddedListItemAdapterTest >> newNestedRowPresenterFrom: aPresenter [

	| label nested row |
	row := aPresenter newPresenter.
	label := row newLabel.
	nested := row newPresenter.
	nested layout: (SpBoxLayout newHorizontal
			 add: label;
			 yourself).
	row layout: (SpBoxLayout newHorizontal
			 add: nested;
			 yourself).
	^ row
]

{ #category : #running }
SpToploEmbeddedListItemAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #running }
SpToploEmbeddedListItemAdapterTest >> tearDown [

	application ifNotNil: [ application windows do: [ :each | each delete ] ].
	super tearDown
]

{ #category : #tests }
SpToploEmbeddedListItemAdapterTest >> testEasyListViewPresenterRowsKeepEmbeddedPanesTransparent [

	| listElement presenter |
	presenter := SpEasyListViewPresenter new.
	presenter
		application: application;
		items: { #alpha }.
	presenter open.
	self waitUntilUIRedrawed.
	listElement := self firstDescendantOfClass: ToListElement in: presenter adapter widget.
	self assert: listElement isNotNil.
	self assertEmbeddedPanesTransparentInFirstNodeOf: listElement
]

{ #category : #tests }
SpToploEmbeddedListItemAdapterTest >> testListViewPresenterRowsKeepEmbeddedPanesTransparent [

	| presenter |
	presenter := SpListViewPresenter new.
	presenter
		application: application;
		items: { #alpha };
		setup: [ :aPresenter | self newNestedRowPresenterFrom: aPresenter ];
		bind: [ :rowPresenter :item | self bindNestedRowPresenter: rowPresenter to: item ].
	presenter open.
	self waitUntilUIRedrawed.
	self assertEmbeddedPanesTransparentInFirstNodeOf: presenter adapter widget
]

{ #category : #tests }
SpToploEmbeddedListItemAdapterTest >> testTablePresenterRowsKeepEmbeddedPanesTransparent [

	| presenter |
	presenter := SpTablePresenter new.
	presenter
		application: application;
		items: #('Alpha' 'Beta');
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #asString);
		addColumn: (SpCompositeTableColumn new
			title: 'Composite';
			addColumn: (SpStringTableColumn title: 'Sub' evaluated: #asString);
			yourself).
	presenter open.
	self waitUntilUIRedrawed.
	self assertEmbeddedPanesTransparentInFirstNodeOf: presenter adapter widget list
]

{ #category : #tests }
SpToploEmbeddedListItemAdapterTest >> testTreeListViewPresenterRowsKeepEmbeddedPanesTransparent [

	| presenter |
	presenter := SpTreeListViewPresenter new.
	presenter
		application: application;
		roots: { #alpha };
		children: [ :ignored | #(  ) ];
		setup: [ :aPresenter | self newNestedRowPresenterFrom: aPresenter ];
		bind: [ :rowPresenter :item | self bindNestedRowPresenter: rowPresenter to: item ].
	presenter open.
	self waitUntilUIRedrawed.
	self assertEmbeddedPanesTransparentInFirstNodeOf: presenter adapter widget
]

{ #category : #tests }
SpToploEmbeddedListItemAdapterTest >> testTreeTablePresenterRowsKeepEmbeddedPanesTransparent [

	| presenter |
	presenter := SpTreeTablePresenter new.
	presenter
		application: application;
		roots: #('Alpha' 'Beta');
		children: [ :ignored | #(  ) ];
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #asString);
		addColumn: (SpCompositeTableColumn new
			title: 'Composite';
			addColumn: (SpStringTableColumn title: 'Sub' evaluated: #asString);
			yourself).
	presenter open.
	self waitUntilUIRedrawed.
	self assertEmbeddedPanesTransparentInFirstNodeOf: presenter adapter widget list
]

{ #category : #running }
SpToploEmbeddedListItemAdapterTest >> waitUntilUIRedrawed [

	| aSpace |
	aSpace := application windows anyOne adapter widget.
	aSpace settleForDuration: 500 milliSeconds
]
