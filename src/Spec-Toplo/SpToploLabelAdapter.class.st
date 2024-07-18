"
I'm a Spec adapter for `SpLabelPresenter`.
"
Class {
	#name : #SpToploLabelAdapter,
	#superclass : #SpToploWidgetAdapter,
	#traits : 'SpToploTWithContextMenu',
	#classTraits : 'SpToploTWithContextMenu classTrait',
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploLabelAdapter >> buildWidget [

	^ ToLabel new
]

{ #category : #accessing }
SpToploLabelAdapter >> font [
	
	^ self notYetImplemented
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

{ #category : #'updating widget' }
SpToploLabelAdapter >> updateAll [

	super updateAll.

	self
		updateLabel;
		updateMenu
]

{ #category : #'updating widget' }
SpToploLabelAdapter >> updateLabel [

	widget text: model label
]
