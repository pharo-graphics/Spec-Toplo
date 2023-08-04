"
I'm a Spec adapter for `SpButtonPresenter`.
"
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

	^ SpToploButton new
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
	
	^ widget iconForm
]

{ #category : #accessing }
SpToploButtonAdapter >> label [

	^ widget labelString
]

{ #category : #factory }
SpToploButtonAdapter >> newContextMenu [

	^ model contextMenu ifNotNil: #build
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

	widget iconFormOrNil: model icon
]

{ #category : #factory }
SpToploButtonAdapter >> updateLabel [

	widget labelString: model label
]

{ #category : #updating }
SpToploButtonAdapter >> updateMenu [
	"No need to act; if the menu is opened, it will use the current one."
]
