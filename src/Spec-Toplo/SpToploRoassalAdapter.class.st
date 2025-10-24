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
	canvas := widget children anyOne roassalShape.
	self model canvas: canvas.
	self applyScript
]

{ #category : #initialization }
SpToploRoassalAdapter >> applyScript [

	| extent aModel |
	extent := canvas extent.
	aModel := self model.
	aModel script value: canvas.
	canvas notifyExtentChanged: extent
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
