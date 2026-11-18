Class {
	#name : #SpToploMenuAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #running }
SpToploMenuAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #tests }
SpToploMenuAdapterTest >> testDisabledMenuItemDoesNotExecuteAction [

	| menu widget item actionRan |
	actionRan := false.
	menu := SpMenuPresenter newApplication: application.
	menu addItem: [ :it |
		it
			name: 'Disabled';
			enabled: false;
			action: [ actionRan := true ] ].
	widget := menu build.
	item := widget items first.

	(item actionPool actionLinks anyOne instVarNamed: #action) value.
	self deny: actionRan
]

{ #category : #tests }
SpToploMenuAdapterTest >> testMenuItemDisabled [

	| menu widget item |
	menu := SpMenuPresenter newApplication: application.
	menu addItem: [ :it |
		it
			name: 'Item';
			enabled: false ].
	widget := menu build.
	item := widget items first.

	self deny: item isEnabled
]

{ #category : #tests }
SpToploMenuAdapterTest >> testMenuItemDynamicEnablement [

	| menu widget item isItemActive |
	isItemActive := false.
	menu := SpMenuPresenter newApplication: application.
	menu addItem: [ :it |
		it
			name: 'Item';
			enabled: [ isItemActive ] ].
	widget := menu build.
	item := widget items first.

	self deny: item isEnabled
]

{ #category : #tests }
SpToploMenuAdapterTest >> testMenuItemEnabledByDefault [

	| menu widget item |
	menu := SpMenuPresenter newApplication: application.
	menu addItem: [ :it | it name: 'Item' ].
	widget := menu build.
	item := widget items first.

	self assert: item isEnabled
]

{ #category : #tests }
SpToploMenuAdapterTest >> testMenuItemEnablementChanged [

	| menu widget item menuItemPresenter |
	menu := SpMenuPresenter newApplication: application.
	menu addItem: [ :it |
		menuItemPresenter := it.
		it
			name: 'Item';
			enabled: true ].
	widget := menu build.
	item := widget items first.

	self assert: item isEnabled.
	menuItemPresenter enabled: false.
	self deny: item isEnabled
]

{ #category : #tests }
SpToploMenuAdapterTest >> testMenuItemShortcut [

	| menu item widget shortcutLabel |
	menu := SpMenuPresenter newApplication: application.
	menu addItem: [ :it |
		it
			name: 'Packages';
			shortcut: $p meta;
			action: [ ] ].
	widget := menu build.

	item := widget items first.
	self assert: item isEndFlexible.
	self assert: item endElement hasChildren.

	shortcutLabel := item endElement children first.
	self assert: shortcutLabel isEnabled.
	self assert: shortcutLabel text asString equals: '⌘P'
]

{ #category : #tests }
SpToploMenuAdapterTest >> testMenuItemShortcutDisabled [

	| menu itemPresenter widget item shortcutLabel |
	menu := SpMenuPresenter newApplication: application.
	menu addItem: [ :it |
		itemPresenter := it.
		it
			name: 'Packages';
			shortcut: $p meta;
			enabled: true;
			action: [ ] ].
	widget := menu build.

	item := widget items first.
	shortcutLabel := item endElement children first.
	self assert: shortcutLabel isEnabled.

	itemPresenter enabled: false.
	self deny: item isEnabled.
	self deny: shortcutLabel isEnabled
]

{ #category : #tests }
SpToploMenuAdapterTest >> testUnsubscribeRemovesSubscriptionsFromDynamicallyRemovedMenuItems [

	| menu item slot |
	menu := SpMenuPresenter newApplication: application.
	menu addItem: [ :it |
		item := it.
		it name: 'Item' ].
	menu build.

	slot := SpMenuItemPresenter slotNamed: #name.
	"Remove the item from the presenter tree before unsubscription"
	menu menuGroups first menuItems remove: item.

	menu adapter unsubscribe.

	self deny: ((slot rawRead: item) subscriptions anySatisfy: [ :s | s receiver == menu adapter ])
]

{ #category : #tests }
SpToploMenuAdapterTest >> testUnsubscribeRemovesSubscriptionsFromMenuItems [

	| menu item slot |
	menu := SpMenuPresenter newApplication: application.
	menu addItem: [ :it |
		item := it.
		it name: 'Item' ].
	menu build.

	slot := SpMenuItemPresenter slotNamed: #name.
	self assert: ((slot rawRead: item) subscriptions anySatisfy: [ :s | s receiver == menu adapter ]).

	menu adapter unsubscribe.

	self deny: ((slot rawRead: item) subscriptions anySatisfy: [ :s | s receiver == menu adapter ])
]

{ #category : #tests }
SpToploMenuAdapterTest >> testUpdateMenuDoesNotAccumulateSubscriptions [

	| menu item slot countBefore |
	menu := SpMenuPresenter newApplication: application.
	menu addItem: [ :it |
		item := it.
		it name: 'Item' ].
	menu build.

	slot := SpMenuItemPresenter slotNamed: #name.
	countBefore := (slot rawRead: item) subscriptions size.

	menu adapter updateMenu.
	menu adapter updateMenu.

	self assert: (slot rawRead: item) subscriptions size equals: countBefore
]
