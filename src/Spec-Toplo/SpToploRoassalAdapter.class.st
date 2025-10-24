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
	canvas := widget children anyOne.
	self model canvas: canvas roassalShape.
	self applyScript
]

{ #category : #initialization }
SpToploRoassalAdapter >> applyScript [

	| extent aModel |
	canvas := self model canvas.
	extent := canvas extent.
	"self freeCanvas."
	aModel := self model.
	aModel script value: canvas.
	aModel canvas: canvas.
	canvas notifyExtentChanged: extent.
	"self updateBlocElement "
]

{ #category : #factory }
SpToploRoassalAdapter >> buildWidget [
	| element |
	element := ToElement new.
	element addChild: RSCanvas new useBlocHost host canvasElement.
	^ element
	
	
	
]

{ #category : #dependencies }
SpToploRoassalAdapter >> release [
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]
