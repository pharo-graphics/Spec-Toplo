"
I'm a Spec adapter for `SpToggleButtonPresenter`.
"
Class {
	#name : #SpToploToggleButtonAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploToggleButtonAdapter >> buildWidget [

	^ ToToggleButton new
]

{ #category : #accessing }
SpToploToggleButtonAdapter >> label [
	
	^ widget labelText
]

{ #category : #accessing }
SpToploToggleButtonAdapter >> state [

	^ widget checked
]

{ #category : #initialization }
SpToploToggleButtonAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	
	model
		whenChangedDo: [ self updateState ];
		whenLabelChangedDo: [ self updateLabel ]
]

{ #category : #initialization }
SpToploToggleButtonAdapter >> subscribeToWidget [

	super subscribeToWidget.

	widget
		addEventHandlerOn: ToCheckableCheckEvent
		do: [ :event | model state: widget checked ]
]

{ #category : #'updating widget' }
SpToploToggleButtonAdapter >> updateAll [

	super updateAll.

	self
		updateState;
		updateLabel
]

{ #category : #'updating widget' }
SpToploToggleButtonAdapter >> updateLabel [

	widget labelText: model label
]

{ #category : #'updating widget' }
SpToploToggleButtonAdapter >> updateState [

	widget checked: model state
]
