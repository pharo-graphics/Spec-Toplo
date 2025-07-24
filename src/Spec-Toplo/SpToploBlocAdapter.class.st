Class {
	#name : #SpToploBlocAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploBlocAdapter >> buildWidget [

	^ ToElement new
]

{ #category : #initialization }
SpToploBlocAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenBlocElementChangedDo: [ self updateBlocElement ]
]

{ #category : #initialization }
SpToploBlocAdapter >> updateAll [

	super updateAll.

	self updateBlocElement
]

{ #category : #initialization }
SpToploBlocAdapter >> updateBlocElement [

	widget removeChildren.

	"If element is nil then we just ensure remove all"
	model blocElement ifNil: [ ^ self ].

	widget addChild: model blocElement
]
