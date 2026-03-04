"
I'm a Spec adapter for `SpModalWindowPresenter`.
"
Class {
	#name : #SpToploModalWindowAdapter,
	#superclass : #SpToploDialogWindowAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #testing }
SpToploModalWindowAdapter >> isDisplayed [
	^ self widget isOpened 
]
