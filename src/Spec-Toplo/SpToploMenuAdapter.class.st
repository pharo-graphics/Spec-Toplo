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

{ #category : #factory }
SpToploMenuAdapter >> updateMenu [

	"Reset"
	widget items do: [ :each | widget removeItem: each ].

	"Add menu groups"
	self addMenuGroups: model menuGroups into: widget
]
