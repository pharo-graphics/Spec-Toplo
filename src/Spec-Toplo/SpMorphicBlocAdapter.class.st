"
I'm a Spec adapter for `SpBlocPresenter` to the Morphic backend.
"
Class {
	#name : #SpMorphicBlocAdapter,
	#superclass : #SpAbstractMorphicAdapter,
	#instVars : [
		'space'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpMorphicBlocAdapter >> buildWidget [

	widget := Morph new.
	widget
		color: Color transparent;
		layoutPolicy: TableLayout new.

	space := BlSpace new.
	space host:
		(BlMorphicHost new
			containerMorph: widget;
			yourself).
	space show.

	self refreshBlocElement.
	self presenter whenBlocElementChangedDo: [ self refreshBlocElement ].
	
	^ widget
]

{ #category : #'widget API' }
SpMorphicBlocAdapter >> refreshBlocElement [

	space root removeChildren.
	
	model blocElement
		ifNotNil: [ :e | space root addChild: e ]
]
