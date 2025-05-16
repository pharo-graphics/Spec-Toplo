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
		ifNil: [ | leaf |
			leaf := ToMenuItem new.
			item action ifNotNil: [ :ic | leaf 	clickAction: ic ].
			item icon ifNotNil: [ :ic | leaf 	iconImage: ic ].
			item name ifNotNil: [ :n | leaf 	labelText: n ].
			parentMenu addItem: leaf ]

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
	widget menus do: [ :each | widget removeMenu: each ].

	"Add menu groups"
	self addMenuGroups: model menuGroups into: widget
]
