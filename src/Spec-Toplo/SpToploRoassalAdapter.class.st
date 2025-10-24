Class {
	#name : #SpToploRoassalAdapter,
	#superclass : #SpToploAdapter,
	#instVars : [
		'canvas'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #initialization }
SpToploRoassalAdapter >> adapt: aComposableModel [

	super adapt: aComposableModel.
	canvas := self model canvas.
	self applyScript
]

{ #category : #initialization }
SpToploRoassalAdapter >> applyScript [

	| extent aModel |
	extent := canvas extent.
	aModel := self model.
	aModel script value: canvas.
	canvas notifyExtentChanged: extent.
	self updateBlocElement
]

{ #category : #factory }
SpToploRoassalAdapter >> buildWidget [
	| element |
	element := ToElement new.
	^ element
	
	
	
]

{ #category : #dependencies }
SpToploRoassalAdapter >> release [
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]

{ #category : #factory }
SpToploRoassalAdapter >> updateBlocElement [

	widget removeChildren.

	widget addChild: canvas useBlocHost host canvasElement
]
