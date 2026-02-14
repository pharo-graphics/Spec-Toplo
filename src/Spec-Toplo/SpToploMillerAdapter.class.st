Class {
	#name : #SpToploMillerAdapter,
	#superclass : #SpToploLayoutAdapter,
	#instVars : [
		'list'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploMillerAdapter >> addChildElement: aWidget with: aSpGridConstraints [

	self list dataAccessor add: aWidget.
	self list whenLayoutedDoOnce: [ :layout | self recomputeAllWidth ]
]

{ #category : #adding }
SpToploMillerAdapter >> addConstraints: constraints toChild: childBlElement [

	^ childBlElement
]

{ #category : #adding }
SpToploMillerAdapter >> list [

	^ list
]

{ #category : #'instance creation' }
SpToploMillerAdapter >> newChildBlElement: aPresenter constrainedBy: constraints [
	^ self newBlElementFrom: aPresenter constraints: constraints
]

{ #category : #'instance creation' }
SpToploMillerAdapter >> newToploWidget [

	| hscrollBar element |
	element := ToElement new.
	list := ToListElement finite
		        beHorizontal;
		        matchParent;
		        yourself.
	list selecter disable.
	hscrollBar := BlHorizontalScrollbarElement new.
	hscrollBar constraintsDo: [ :c |
			c ignoreByLayout.
			c margin: (BlInsets right: 2).
			c ignored horizontal alignRight.
			c ignored vertical alignBottom ].
	hscrollBar attachTo: list innerElement.
	list nodeBuilder: [ :node :dataItem :holder |
		node addChild: dataItem ].

	element addChild: list.
	element addChild: hscrollBar.

	^ element
]

{ #category : #adding }
SpToploMillerAdapter >> recomputeAllWidth [

	self list dataAccessor size = 1
		ifTrue: [
			self list dataAccessor first width: self list width - 24 "magic number that should be retrieve somewhere" ]
		ifFalse: [
				self list dataAccessor do: [ :child |
					child width: self list width / 2 - 16 "magic number that should be retrieve somewhere" ] ]
]

{ #category : #adding }
SpToploMillerAdapter >> remove: aStObjectInspectorPresenter [

	self list dataAccessor remove:
		aStObjectInspectorPresenter adapter widget.
	self recomputeAllWidth
]

{ #category : #adding }
SpToploMillerAdapter >> selectPage: aPosition [

	self list scrollToDataSourcePosition: aPosition
]

{ #category : #initialization }
SpToploMillerAdapter >> subscribeToWidget [

	self list whenLayoutedDoOnce: [ :layout |
			self list space root
				addEventHandlerOn: BlElementExtentChangedEvent
				do: [ :ann | self recomputeAllWidth ] ]
]
