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

	item subMenu
		ifNil: [
			"Leaf"
			parentMenu addItem:
				(ToMenuItem new
					clickAction: item action;
					iconImage: item icon;
					labelText: item name;
					yourself) ]

		ifNotNil: [ :subMenuPresenter |
			"Node"
			| subMenuWidget |
			subMenuWidget :=
				ToMenu new
					labelText: item name;
					yourself.
			self
				addMenuGroups: subMenuPresenter menuGroups
				into: subMenuWidget.

			parentMenu addItem: subMenuWidget ]
]

{ #category : #'instance creation' }
SpToploMenuLikeAdapter >> addMenuGroups: menuGroups into: aToMenu [

	menuGroups do: [ :aGroup |
		aGroup menuItems do: [ :item | 
			self addMenuFor: item into: aToMenu ] ]
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
