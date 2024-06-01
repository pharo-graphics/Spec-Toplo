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

	^ ToLabel new
]

{ #category : #accessing }
SpToploLabelAdapter >> label [
	
	^ widget text asString
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

	widget text: model label
]
