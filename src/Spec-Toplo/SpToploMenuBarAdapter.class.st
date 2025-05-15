"
I'm a Spec adapter for `SpMenuBarPresenter`.
"
Class {
	#name : #SpToploMenuBarAdapter,
	#superclass : #SpToploMenuLikeAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'instance creation' }
SpToploMenuBarAdapter >> addMenuFor: item into: parentMenu [

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

{ #category : #factory }
SpToploMenuBarAdapter >> addMenuGroup: aGroup [

	aGroup menuItems do: [ :item | 
		| menu |
		menu := self newMenuFor: item.

		widget addMenu: menu ].
]

{ #category : #'instance creation' }
SpToploMenuBarAdapter >> addMenuGroups: menuGroups into: aToMenu [

	menuGroups do: [ :aGroup |
		aGroup menuItems do: [ :item | 
			self addMenuFor: item into: aToMenu ] ]
]

{ #category : #factory }
SpToploMenuBarAdapter >> buildWidget [

	^ ToMenuBar new
]

{ #category : #'instance creation' }
SpToploMenuBarAdapter >> newMenuFor: item [ 

	^ item subMenu
			ifNil: [
				"Leaf"
				ToMenuItem new
					whenClickedDo: item action;
					labelText: item name;
					yourself ]
			ifNotNil: [ :menuPresenter |
				"Node"
				|menu|
				menu := ToMenu new
					labelText: item name;
					yourself.
				self addMenuGroups: item subMenu menuGroups into: menu.
				menu ]

]

{ #category : #'instance creation' }
SpToploMenuBarAdapter >> newMenuItemsFor: aSpMenuPresenter [ 

	^ aSpMenuPresenter menuGroups
		collect: [ :e | self addMenuGroup: e ]
]

{ #category : #factory }
SpToploMenuBarAdapter >> updateAll [

	super updateAll.
	
	self updateMenu
]

{ #category : #factory }
SpToploMenuBarAdapter >> updateLayout [

	widget
		hMatchParent;
		vFitContent
]

{ #category : #factory }
SpToploMenuBarAdapter >> updateMenu [

	"Reset"
	widget items do: [ :each | widget removeItem: each ].

	"Add menu groups"
	self addMenuGroups: model menuGroups into: widget
]
