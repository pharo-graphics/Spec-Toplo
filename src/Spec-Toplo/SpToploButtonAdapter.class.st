"
I'm a Spec adapter for `SpButtonPresenter`.
"
Class {
	#name : 'SpToploButtonAdapter',
	#superclass : 'SpToploWidgetAdapter',
	#instVars : [
		'nullIcon'
	],
	#category : 'Spec-Toplo-Adapters',
	#package : 'Spec-Toplo',
	#tag : 'Adapters'
}

{ #category : 'factory' }
SpToploButtonAdapter >> buildWidget [

	^ ToButton new
		whenClickedDo: [ model performAction ];
"		contextMenu: [ :win :request |
			win addItem:
				(ToMenuItem new
					 labelText: 'Open';
					 whenClickedDo: [ self inform: 'Open' ];
					 yourself) ];"
"		addEventHandler: (BlEventHandler
			on: BlMouseDownEvent secondary
			do: [ self showContextMenu ]);"
"		contextMenuFactory: [ self newContextMenu ];"
		yourself
]

{ #category : 'accessing' }
SpToploButtonAdapter >> icon [
	
	^ widget userData at: #specIcon ifAbsent: [ nil ]
]

{ #category : 'accessing' }
SpToploButtonAdapter >> label [

	^ widget labelText
]

{ #category : 'factory' }
SpToploButtonAdapter >> newContextMenu [

	^ model contextMenu ifNotNil: #build
]

{ #category : 'factory' }
SpToploButtonAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	
	model
		whenLabelChangedDo: [ self updateLabel ];
		whenIconChangedDo: [ self updateIcon ];
		whenActionChangedDo: [ self updateAction ]
]

{ #category : 'factory' }
SpToploButtonAdapter >> updateAction [
	"Nothing to do as widget was built already with its definitive event handler."
]

{ #category : 'factory' }
SpToploButtonAdapter >> updateAll [

	super updateAll.
	self
		updateLabel;
		updateIcon;
		updateAction
]

{ #category : 'factory' }
SpToploButtonAdapter >> updateIcon [

	widget userData at: #specIcon put: model icon.
	widget iconImage: model icon
]

{ #category : 'factory' }
SpToploButtonAdapter >> updateLabel [

	widget labelText: model label
]

{ #category : 'updating' }
SpToploButtonAdapter >> updateMenu [
	"No need to act; if the menu is opened, it will use the current one."
]
