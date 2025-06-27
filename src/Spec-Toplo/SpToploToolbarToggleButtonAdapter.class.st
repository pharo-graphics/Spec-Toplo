Class {
	#name : #SpToploToolbarToggleButtonAdapter,
	#superclass : #SpToploToolbarButtonAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploToolbarToggleButtonAdapter >> buildWidget [

	| menu |
	menu := ToToggleMenuItem new.
	menu vertical: true.
	menu alignCenter: true.
	^ menu
]

{ #category : #initialization }
SpToploToolbarToggleButtonAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenToggledDo: [ self updateToggledState ]
]

{ #category : #initialization }
SpToploToolbarToggleButtonAdapter >> updateAction [

	model action ifNotNil: [ widget checkAction: model action ]
]

{ #category : #initialization }
SpToploToolbarToggleButtonAdapter >> updateAll [

	super updateAll.
	self updateToggledState
]

{ #category : #initialization }
SpToploToolbarToggleButtonAdapter >> updateToggledState [

	widget checked: model state
]
