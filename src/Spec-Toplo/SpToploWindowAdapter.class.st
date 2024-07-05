"
I'm a Spec adapter for `SpWindowPresenter`.
"
Class {
	#name : #SpToploWindowAdapter,
	#superclass : #SpToploWindowLikeAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #hook }
SpToploWindowAdapter >> newRootElement [

	^ SpToploWindowElement new
]
