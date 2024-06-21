Class {
	#name : #SpToploToggleButtonAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #accessing }
SpToploToggleButtonAdapter >> label [
	
	^ widget labelText
]

{ #category : #'accessing - structure variables' }
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

{ #category : #initialization }
SpToploToggleButtonAdapter >> updateAll [

	super updateAll.

	self
		updateState;
		updateLabel
]

{ #category : #updating }
SpToploToggleButtonAdapter >> updateLabel [

	widget labelText: model label
]

{ #category : #updating }
SpToploToggleButtonAdapter >> updateState [

	widget checked: model state
]
