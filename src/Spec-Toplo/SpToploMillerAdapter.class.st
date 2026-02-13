Class {
	#name : #SpToploMillerAdapter,
	#superclass : #SpToploLayoutAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploMillerAdapter >> addChildElement: aWidget with: aSpGridConstraints [

	widget dataAccessor add: aWidget.
	self recomputeAllWidth
]

{ #category : #adding }
SpToploMillerAdapter >> addConstraints: constraints toChild: childBlElement [

	^ childBlElement
]

{ #category : #'instance creation' }
SpToploMillerAdapter >> newChildBlElement: aPresenter constrainedBy: constraints [
	^ self newBlElementFrom: aPresenter constraints: constraints
]

{ #category : #'instance creation' }
SpToploMillerAdapter >> newToploWidget [

	| list |
	list := ToListElement finite
		        beHorizontal;
		        matchParent;
		        yourself.
	list nodeBuilder: [ :node :dataItem :holder |
		node addChild: dataItem ].
	^ list
]

{ #category : #adding }
SpToploMillerAdapter >> recomputeAllWidth [

	widget whenLayoutedDoOnce: [ :layout |
			widget dataAccessor size = 1
				ifTrue: [ widget dataAccessor first width: widget width ]
				ifFalse: [
				widget dataAccessor do: [ :child | child width: widget width / 2 ] ] ]
]

{ #category : #adding }
SpToploMillerAdapter >> remove: aStObjectInspectorPresenter [

	self widget dataAccessor remove: aStObjectInspectorPresenter adapter widget
]

{ #category : #adding }
SpToploMillerAdapter >> selectPage: aPosition [

	widget scrollToDataSourcePosition: aPosition
]
