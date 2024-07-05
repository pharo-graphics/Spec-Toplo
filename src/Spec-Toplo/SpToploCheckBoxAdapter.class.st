"
I'm a Spec adapter for `SpCheckBoxPresenter`.
"
Class {
	#name : #SpToploCheckBoxAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploCheckBoxAdapter >> buildWidget [

	^ ToCheckbox new
]

{ #category : #accessing }
SpToploCheckBoxAdapter >> label [
	
	^ widget labelText
]

{ #category : #accessing }
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
SpToploCheckBoxAdapter >> subscribeToWidget [

	super subscribeToWidget.

	widget
		addEventHandlerOn: ToCheckableCheckEvent
		do: [ :event | model state: widget checked ]
]

{ #category : #'updating widget' }
SpToploCheckBoxAdapter >> updateAll [

	super updateAll.

	self
		updateLabel;
		updateState
]

{ #category : #'updating widget' }
SpToploCheckBoxAdapter >> updateLabel [

	widget labelText: model label
]

{ #category : #'updating widget' }
SpToploCheckBoxAdapter >> updateState [

	widget checked: model state
]
