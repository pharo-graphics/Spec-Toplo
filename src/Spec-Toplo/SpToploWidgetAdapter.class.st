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

	^ widget userData at: #specHelpText ifAbsent: [ nil ]
]

{ #category : #emulating }
SpToploWidgetAdapter >> sendRightClickEvent [

	BlSpace simulateSecondaryClickOn: widget
]

{ #category : #initialization }
SpToploWidgetAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenHelpChangedDo: [ self updateHelp ]
]

{ #category : #initialization }
SpToploWidgetAdapter >> updateAll [

	super updateAll.
	self
		updateEnabled;
		updateHelp
]

{ #category : #'updating widget' }
SpToploWidgetAdapter >> updateEnabled [

	widget enabled: model isEnabled
]

{ #category : #'updating widget' }
SpToploWidgetAdapter >> updateHelp [

	widget userData at: #specHelpText put: model help.
	widget tooltipString: model help
]
