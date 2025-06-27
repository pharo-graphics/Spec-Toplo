"
I'm a Spec adapter for `SpToolbarPresenter`.
"
Class {
	#name : #SpToploToolbarAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploToolbarAdapter >> buildWidget [

	| menu |
	menu := ToMenuPane new.
"	menu vertical: true."
"	menu alignCenter: true."
	^ menu
]

{ #category : #'instance creation' }
SpToploToolbarAdapter >> newItemFor: aSpToolbarButtonPresenter [

	^ aSpToolbarButtonPresenter build
]

{ #category : #initialization }
SpToploToolbarAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenItemsChangeDo: [ self updateItems ]
]

{ #category : #initialization }
SpToploToolbarAdapter >> updateAll [

	super updateAll.

	self updateItems
]

{ #category : #'updating widget' }
SpToploToolbarAdapter >> updateItems [

	widget removeAllItems.

	model leftItems do: [ :each |
		widget addItem: (self newItemFor: each) ].

	model rightItems do: [ :each |
		widget addItem: (self newItemFor: each) ]
]

{ #category : #factory }
SpToploToolbarAdapter >> updateLayout [

	widget
		hMatchParent;
		vFitContent
]
