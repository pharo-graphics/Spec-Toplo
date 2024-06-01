Class {
	#name : #SpToploCheckBoxAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploCheckBoxAdapter >> buildWidget [

	^ ToCheckbox new
		addEventHandlerOn: ToCheckableCheckEvent
			do: [ :event | model state: widget checked ];
		yourself
]

{ #category : #'accessing - structure variables' }
SpToploCheckBoxAdapter >> label [
	
	^ widget labelText
]

{ #category : #'accessing - structure variables' }
SpToploCheckBoxAdapter >> state [

	^ widget checked
]

{ #category : #initialization }
SpToploCheckBoxAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	
	model
		whenLabelChangedDo: [ self updateLabel ];
		whenChangedDo: [ self updateState ]
]

{ #category : #initialization }
SpToploCheckBoxAdapter >> updateAll [

	super updateAll.
	self
		updateLabel;
		updateState
]

{ #category : #updating }
SpToploCheckBoxAdapter >> updateLabel [

	widget labelText: model label
]

{ #category : #updating }
SpToploCheckBoxAdapter >> updateState [

	widget checked: model state
]
