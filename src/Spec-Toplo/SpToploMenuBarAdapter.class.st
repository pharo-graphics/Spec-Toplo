"
I'm a Spec adapter for `SpMenuBarPresenter`.
"
Class {
	#name : #SpToploMenuBarAdapter,
	#superclass : #SpToploMenuLikeAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploMenuBarAdapter >> addMenuGroup: aGroup [

	aGroup menuItems do: [ :item | 
		| menu |
		menu := self newMenuFor: item.

		widget addMenu: menu ].
]

{ #category : #factory }
SpToploMenuBarAdapter >> buildWidget [

	^ ToMenuPane new
]

{ #category : #'instance creation' }
SpToploMenuBarAdapter >> newMenuFor: item [ 

	^ item subMenu
			ifNil: [
				"Leaf"
				ToMenuItem new
					clickAction: item action;
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

{ #category : #initialization }
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
