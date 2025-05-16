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

	self widgetDo: [ :w | w labelText: 'XXX Menu'; openInSpace "invokeAt: (aPoint + (2@7)) in: self currentWorld allowKeyboard: true" ]
]

{ #category : #factory }
SpToploMenuAdapter >> updateMenu [

	"Reset"
	widget items do: [ :each | widget removeItem: each ].

	"Add menu groups"
	self addMenuGroups: model menuGroups into: widget
]
