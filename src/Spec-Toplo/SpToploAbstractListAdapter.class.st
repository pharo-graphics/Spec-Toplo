Class {
	#name : #SpToploAbstractListAdapter,
	#superclass : #SpToploWidgetAdapter,
	#traits : 'SpToploTWithContextMenu',
	#classTraits : 'SpToploTWithContextMenu classTrait',
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploAbstractListAdapter >> buildWidget [

	^ ToListElement new
		nodeBuilder: [ :node :dataItem :holder |
		  node addChild: (self newItemElementFor: dataItem) ];
		yourself
]

{ #category : #accessing }
SpToploAbstractListAdapter >> elementAt: anInteger [ 
	
	^ widget dataAccessor at: anInteger
]

{ #category : #testing }
SpToploAbstractListAdapter >> isNonEditableRow: aRow column: aColumn [

	self flag: #todo.
	^ true
]

{ #category : #'instance creation' }
SpToploAbstractListAdapter >> newItemElementFor: anItem [
	"Answer a new `BlElement` to represent the received item. In the case of the SpListPresenter, the item is one of the objects set in the collection via `SpAbstractListPresenter>>#items:` (so, it's not a wrapper)."

	^ self subclassResponsibility
]

{ #category : #refreshing }
SpToploAbstractListAdapter >> refreshList [

]

{ #category : #factory }
SpToploAbstractListAdapter >> refreshWidgetList [

	widget notifyDataSourceChanged
]

{ #category : #accessing }
SpToploAbstractListAdapter >> refreshWidgetSelection [

	self updateSelection
]

{ #category : #accessing }
SpToploAbstractListAdapter >> selectIndex: anInteger [ 
	
	widget selecter selectOnlyIndex: anInteger
]

{ #category : #accessing }
SpToploAbstractListAdapter >> selectedIndexes [
	
	^ widget selecter selectedIndexes
]

{ #category : #initialization }
SpToploAbstractListAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model
		whenModelChangedDo: [ self updateItems ];
		whenSelectionChangedDo: [ self updateSelection ];
		whenSelectionModeChangedDo: [ self updateSelectionMode ]
]

{ #category : #initialization }
SpToploAbstractListAdapter >> subscribeToWidget [

	super subscribeToWidget.

	widget
		addEventHandlerOn: ToListPrimarySelectionChangedEvent
			do: [ model selection selectIndexes: widget selecter selectedIndexes ];
		addEventHandlerOn: ToListStrongSelectionEvent
			do: [ model doActivateAtIndex: model selection selectedIndex ]
]

{ #category : #initialization }
SpToploAbstractListAdapter >> updateAll [

	super updateAll.

	self
		updateItems;
		updateSelection;
		updateMenu
]

{ #category : #'updating widget' }
SpToploAbstractListAdapter >> updateItems [

	widget dataAccessor
		removeAll;
		addAll: model items
]

{ #category : #'updating widget' }
SpToploAbstractListAdapter >> updateSelection [

	model selection selectedIndexes ifEmpty: [
		^ widget selecter deselectAll ].
	widget selecter selectIndexes: model selection selectedIndexes
]

{ #category : #'updating widget' }
SpToploAbstractListAdapter >> updateSelectionMode [

	widget selecter multiple: self model isMultipleSelection
]
