"
I'm a Spec adapter for `SpMenuPresenter`.
"
Class {
	#name : #SpToploMenuAdapter,
	#superclass : #SpToploMenuLikeAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploMenuAdapter >> buildWidget [

	^ ToMenu new
]

{ #category : #accessing }
SpToploMenuAdapter >> openAt: aPoint [

	widget forceLayout.
	widget labelText: 'Menu'.
	widget openInSpace
		extent: widget size;
		position: aPoint
]
