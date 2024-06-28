Class {
	#name : #SpToploRadioButtonAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploRadioButtonAdapter >> buildWidget [

	^ ToRadioButton new
]

{ #category : #accessing }
SpToploRadioButtonAdapter >> label [
	
	^ widget labelText
]

{ #category : #accessing }
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

{ #category : #'updating widget' }
SpToploRadioButtonAdapter >> updateAll [

	super updateAll.

	self
		updateLabel;
		updateState
]

{ #category : #'updating widget' }
SpToploRadioButtonAdapter >> updateLabel [

	widget labelText: model label
]

{ #category : #'updating widget' }
SpToploRadioButtonAdapter >> updateState [

	widget checked: model state
]
