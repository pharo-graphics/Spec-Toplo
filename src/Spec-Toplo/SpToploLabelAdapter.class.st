"
I'm a Spec adapter for `SpLabelPresenter`.
"
Class {
	#name : #SpToploLabelAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploLabelAdapter >> buildWidget [

	^ SpToploLabel new
]

{ #category : #accessing }
SpToploLabelAdapter >> label [
	
	^ widget labelString
]

{ #category : #initialization }
SpToploLabelAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	
	model whenLabelChangedDo: [ self updateLabel ]
]

{ #category : #initialization }
SpToploLabelAdapter >> updateAll [

	super updateAll.
	self updateLabel
]

{ #category : #updating }
SpToploLabelAdapter >> updateLabel [

	widget labelString: model label
]
