"
I'm a Spec adapter for `SpMenuPresenter`.
"
Class {
	#name : #SpToploMenuAdapter,
	#superclass : #SpToploAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploMenuAdapter >> buildWidget [

	^ ToContextMenu new
]
