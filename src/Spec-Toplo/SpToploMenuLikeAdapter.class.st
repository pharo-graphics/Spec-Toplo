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
		ifNil: [
			toploItem := ToMenuItem new.
			item action ifNotNil: [
				toploItem clickAction: [ (self isItemEnabled: item) ifTrue: [ item performMenuActionWith: toploItem ] ] ] ]
		ifNotNil: [ :subMenuPresenter |
			toploItem := ToMenu new.
			self addMenuGroups: subMenuPresenter menuGroups into: toploItem ].

	item name ifNotNil: [ :o | toploItem labelText: o ].
	item icon ifNotNil: [ :o | toploItem iconImage: o ].
	item description ifNotNil: [ :o | toploItem tooltipText: o ].
	toploItem enabled: (self isItemEnabled: item).

	presenterSubscriptions add: item.

	item whenNameChangedDo: [ :o | toploItem labelText: o ].
	item whenIconChangedDo: [ :o | toploItem iconImage: o ].
	item whenDescriptionChangedDo: [ :o | toploItem tooltipText: o ].
	item whenEnabledChangedDo: [ toploItem enabled: (self isItemEnabled: item) ].

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

{ #category : #testing }
SpToploMenuLikeAdapter >> isItemEnabled: anItem [

	| itemEnabled |
	itemEnabled := anItem isEnabled.

	"Based on SpMorphicMenuItemAdapter"
	(itemEnabled isBlock or: [ itemEnabled isMessageSend ])
		ifTrue: [ itemEnabled := itemEnabled cull: anItem ].

	^ itemEnabled ifNil: [ true ]
]

{ #category : #factory }
SpToploMenuLikeAdapter >> updateAll [

	super updateAll.
	
	self updateMenu
]

{ #category : #factory }
SpToploMenuLikeAdapter >> updateMenu [

	self unsubscribeFromPresenters.

	"Reset"
	widget items do: [ :each | widget removeItem: each ].

	"Add menu groups"
	self addMenuGroups: model menuGroups into: widget
]
