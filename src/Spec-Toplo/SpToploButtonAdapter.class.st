"
I'm a Spec adapter for widgets, in general in the hierarchy of `SpAbstractWidgetPresenter`.
"
Class {
	#name : #SpToploButtonAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploButtonAdapter >> buildWidget [

	^ ToButton new
		contextMenu: [ :win :request |
			self inform: win asString ];
		yourself
]

{ #category : #accessing }
SpToploButtonAdapter >> icon [
	
	^ widget userData at: #specIcon ifAbsent: [ nil ]
]

{ #category : #accessing }
SpToploButtonAdapter >> label [

	^ widget labelText
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

{ #category : #initialization }
SpToploButtonAdapter >> subscribeToWidget [

	super subscribeToWidget.
	
	widget whenClickedDo: [ model performAction ]
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

	widget userData at: #specIcon put: model icon.
	widget iconImage: model icon
]

{ #category : #factory }
SpToploButtonAdapter >> updateLabel [

	widget labelText: model label
]

{ #category : #updating }
SpToploButtonAdapter >> updateMenu [
	"No need to act; if the menu is opened, it will use the current one."
]
