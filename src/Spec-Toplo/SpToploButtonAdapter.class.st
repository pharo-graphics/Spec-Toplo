Class {
	#name : #SpToploButtonAdapter,
	#superclass : #SpToploWidgetAdapter,
	#instVars : [
		'nullIcon'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploButtonAdapter >> buildWidget [

	| pane |
	pane := ToPane new
		fitContent;
		addChild: ToImage new as: #image;
		addChild: ToLabel new as: #label.
	pane layout alignCenter.

	^ ToGeneralButton new
		dresser: ToGeneralButtonDresser new;
		matchParent;
		addChild: pane;
		in: [ :b | b layout alignCenter ];
		addEventHandler: (BlEventHandler
			on: BlClickEvent
			do: [ model performAction ]);
"		addEventHandler: (BlEventHandler
			on: BlMouseDownEvent secondary
			do: [ self showContextMenu ]);"
		contextMenuFactory: [ self newContextMenu ];
		yourself
]

{ #category : #accessing }
SpToploButtonAdapter >> icon [
	
	^ ((widget childAt: 1) childWithId: #image) innerImage
]

{ #category : #accessing }
SpToploButtonAdapter >> label [

	^ ((widget childAt: 1) childWithId: #label) text asString
]

{ #category : #factory }
SpToploButtonAdapter >> newContextMenu [

	^ model contextMenu ifNotNil: #build
]

{ #category : #factory }
SpToploButtonAdapter >> nullIcon [

	^ nullIcon ifNil: [ nullIcon := Form extent: 0 asPoint ]
]

{ #category : #factory }
SpToploButtonAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	
	model
		whenLabelChangedDo: [ self updateLabel ];
		whenIconChangedDo: [ self updateIcon ];
		whenActionChangedDo: [ self updateAction ]
]

{ #category : #factory }
SpToploButtonAdapter >> updateAction [
	"Nothing to do as widget was built already with its definitive event handler."
]

{ #category : #factory }
SpToploButtonAdapter >> updateAll [

	super updateAll.
	self
		updateLabel;
		updateIcon;
		updateAction
]

{ #category : #factory }
SpToploButtonAdapter >> updateIcon [

	| iconForm image |
	iconForm := self presenter icon ifNil: [ self nullIcon ].
	image := (widget childAt: 1) childWithId: #image.
	image innerImage: iconForm
]

{ #category : #factory }
SpToploButtonAdapter >> updateLabel [

	| label |
	label := (widget childAt: 1) childWithId: #label.
	label text: model label
]

{ #category : #updating }
SpToploButtonAdapter >> updateMenu [
	"No need to act; if the menu is opened, it will use the current one."
]
