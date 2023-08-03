Class {
	#name : #SpToploWidgetAdapter,
	#superclass : #SpToploAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #emulating }
SpToploWidgetAdapter >> clicked [
	
	BlSpace simulateClickOn: widget
]

{ #category : #accessing }
SpToploWidgetAdapter >> enabled [

	^ widget isEnabled
]

{ #category : #accessing }
SpToploWidgetAdapter >> enabled: aBoolean [ 
	
	widget enabled: aBoolean
]

{ #category : #accessing }
SpToploWidgetAdapter >> helpText [
	
	^ widget tooltipContent
]

{ #category : #visibility }
SpToploWidgetAdapter >> isVisible [
	
	^ widget isVisible
]

{ #category : #emulating }
SpToploWidgetAdapter >> sendRightClickEvent [

	BlSpace simulateSecondaryClickOn: widget
]

{ #category : #initialization }
SpToploWidgetAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model
		whenVisibleChangedDo: [ self updateVisible ];
		whenHelpChangedDo: [ self updateHelp ]
]

{ #category : #initialization }
SpToploWidgetAdapter >> updateAll [

	super updateAll.
	self
		updateEnabled;
		updateVisible;
		updateHelp.
]

{ #category : #updating }
SpToploWidgetAdapter >> updateEnabled [

	widget enabled: model isEnabled
]

{ #category : #updating }
SpToploWidgetAdapter >> updateHelp [

	widget tooltipContent: model help asRopedText
]

{ #category : #updating }
SpToploWidgetAdapter >> updateVisible [

	widget visibility:
		(model isVisible
			ifTrue: [ BlVisibility visible ]
			ifFalse: [ BlVisibility hidden ])
]
