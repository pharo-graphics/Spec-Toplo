"
I'm a Spec adapter for `SpMenuBarPresenter`.
"
Class {
	#name : #SpToploMenuBarAdapter,
	#superclass : #SpToploMenuLikeAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploMenuBarAdapter >> buildWidget [

	^ ToMenuPane new
]

{ #category : #initialization }
SpToploMenuBarAdapter >> updateLayout [

	widget
		hMatchParent;
		vFitContent
]
