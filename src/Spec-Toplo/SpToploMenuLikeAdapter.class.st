"
I'm a Spec adapter for menu-like widgets
"
Class {
	#name : #SpToploMenuLikeAdapter,
	#superclass : #SpToploAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'instance creation' }
SpToploMenuLikeAdapter >> addMenuFor: item into: parentMenu [
	"Create a Toplo item for the received argument and add it to the menu."

	| toploItem |
	item subMenu
		ifNil: [ toploItem := ToMenuItem new ]
		ifNotNil: [ :subMenuPresenter |
			toploItem := ToMenu new.
			self
				addMenuGroups: subMenuPresenter menuGroups
				into: toploItem ].

	item name   ifNotNil: [ :o | toploItem labelText: o ].
	item icon   ifNotNil: [ :o | toploItem iconImage: o ].
	item action ifNotNil: [ :o | toploItem clickAction: o ].

	parentMenu addItem: toploItem
]

{ #category : #'instance creation' }
SpToploMenuLikeAdapter >> addMenuGroups: menuGroups into: aToMenu [

	menuGroups
		do: [ :aGroup |
			aGroup menuItems do: [ :item |
				self addMenuFor: item into: aToMenu ] ]
		separatedBy: [ aToMenu addSeparator ]
]

{ #category : #factory }
SpToploMenuLikeAdapter >> updateAll [

	super updateAll.
	
	self updateMenu
]

{ #category : #factory }
SpToploMenuLikeAdapter >> updateMenu [

	"Reset"
	widget items do: [ :each | widget removeItem: each ].

	"Add menu groups"
	self addMenuGroups: model menuGroups into: widget
]
