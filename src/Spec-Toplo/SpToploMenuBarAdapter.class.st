Class {
	#name : #SpToploMenuBarAdapter,
	#superclass : #SpToploAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'instance creation' }
SpToploMenuBarAdapter >> addMenuFor: item into: parentMenu [

	item subMenu
		ifNil: [
			"Leaf"
			parentMenu addItem:
				(ToMenuItem new
					whenClickedDo: item action;
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

			parentMenu addMenu: subMenuWidget ]
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
	widget menus do: [ :each | widget removeMenu: each ].

	"Add menu groups"
	self addMenuGroups: model menuGroups into: widget
]
