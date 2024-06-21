"
I'm a Spec adapter for `SpListPresenter`.
"
Class {
	#name : #SpToploListAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploListAdapter >> buildWidget [

	^ ToListElement new
]

{ #category : #accessing }
SpToploListAdapter >> elementAt: anInteger [ 
	
	^ widget dataAccessor at: anInteger
]

{ #category : #testing }
SpToploListAdapter >> isNonEditableRow: aRow column: aColumn [

	self flag: #todo.
	^ true
]

{ #category : #factory }
SpToploListAdapter >> refreshWidgetSelection [

	self updateSelection
]

{ #category : #api }
SpToploListAdapter >> selectIndex: anInteger [ 
	
	widget selecter selectOnlyIndex: anInteger
]

{ #category : #accessing }
SpToploListAdapter >> selectedIndexes [
	
	^ widget selecter selectedIndexes
]

{ #category : #initialization }
SpToploListAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model
		whenModelChangedDo: [ self updateItems ];
		whenSelectionChangedDo: [ self updateSelection ]

	"model selection whenChangedDo: [ self refreshWidgetSelection ]."
	"model whenSearchEnabledChangedDo: [ self updateSearch ].
"
]

{ #category : #initialization }
SpToploListAdapter >> subscribeToWidget [

	super subscribeToWidget.

	widget
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
		do: [
			model selection selectIndexes: widget selecter selectedIndexes ]
]

{ #category : #initialization }
SpToploListAdapter >> updateAll [

	super updateAll.

	self
		updateItems;
		updateSelection
]

{ #category : #initialization }
SpToploListAdapter >> updateItems [

	widget dataAccessor
		removeAll;
		addAll: model items
]

{ #category : #initialization }
SpToploListAdapter >> updateSelection [

	widget selecter selectIndexes: model selection selectedIndexes
]
