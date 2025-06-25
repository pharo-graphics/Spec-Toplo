"
I'm a Spec adapter for widgets, in general in the hierarchy of `SpAbstractWidgetPresenter`.
"
Class {
	#name : #SpToploButtonAdapter,
	#superclass : #SpToploWidgetAdapter,
	#traits : 'SpToploTWithContextMenu',
	#classTraits : 'SpToploTWithContextMenu classTrait',
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploButtonAdapter >> buildWidget [

	^ ToButton new
]

{ #category : #accessing }
SpToploButtonAdapter >> icon [
	
	^ widget userData at: #specIcon ifAbsent: [ nil ]
]

{ #category : #accessing }
SpToploButtonAdapter >> label [

	^ widget labelText
]

{ #category : #initialization }
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
	
	widget clickAction: [ model performAction ]
]

{ #category : #'updating widget' }
SpToploButtonAdapter >> updateAction [
	"Nothing to do as widget was built already with its definitive event handler."
]

{ #category : #'updating widget' }
SpToploButtonAdapter >> updateAll [

	super updateAll.

	self
		updateLabel;
		updateIcon;
		updateAction;
		updateMenu
]

{ #category : #'updating widget' }
SpToploButtonAdapter >> updateIcon [

	widget userData at: #specIcon put: model icon.
	widget iconImage: model icon
]

{ #category : #'updating widget' }
SpToploButtonAdapter >> updateLabel [

	widget labelText: model label.

	"The label may include multiple lines (MiniDrTests is example),
	but this can only be set after a label is set."
	widget label beMultiLine
]
