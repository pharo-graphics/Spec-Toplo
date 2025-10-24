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

	| extent |
	extent := canvas extent.
	self freeCanvas.
	self model script value: canvas.
	canvas notifyExtentChanged: extent.
	self updateBlocElement
]

{ #category : #factory }
SpToploRoassalAdapter >> buildWidget [
	| element |
	element := ToElement new.
	^ element
	
	
	
]

{ #category : #initialization }
SpToploRoassalAdapter >> freeCanvas [
	
	canvas := RSCanvas new.
	canvas extent: widget extent
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
