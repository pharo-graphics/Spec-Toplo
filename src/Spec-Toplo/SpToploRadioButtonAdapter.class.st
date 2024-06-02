Class {
	#name : #SpToploRadioButtonAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploRadioButtonAdapter >> buildWidget [

	^ ToRadioButton new
]

{ #category : #'accessing - structure variables' }
SpToploRadioButtonAdapter >> label [
	
	^ widget labelText
]

{ #category : #'accessing - structure variables' }
SpToploRadioButtonAdapter >> state [

	^ widget checked
]

{ #category : #initialization }
SpToploRadioButtonAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	
	model
		whenLabelChangedDo: [ self updateLabel ];
		whenChangedDo: [ self updateState ]
]

{ #category : #initialization }
SpToploRadioButtonAdapter >> subscribeToWidget [

	widget
		addEventHandlerOn: ToCheckableCheckEvent
		do: [ :event | model state: widget checked ]
]

{ #category : #initialization }
SpToploRadioButtonAdapter >> updateAll [

	super updateAll.
	self
		updateLabel;
		updateState
]

{ #category : #updating }
SpToploRadioButtonAdapter >> updateLabel [

	widget labelText: model label
]

{ #category : #updating }
SpToploRadioButtonAdapter >> updateState [

	widget checked: model state
]
