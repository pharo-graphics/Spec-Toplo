Class {
	#name : #SpToploRoassalAdapter,
	#superclass : #SpToploAdapter,
	#instVars : [
		'canvas'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploRoassalAdapter >> adapt: aComposableModel [

	super adapt: aComposableModel.
	canvas := widget.

	self model currentCanvas ifNotNil: [ :aCanvas |
			widget canvas: aCanvas.
			canvas := aCanvas ]
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
	self updateBlocElement 
]

{ #category : #factory }
SpToploRoassalAdapter >> buildWidget [

	^ RSCanvas new useBlocHost host canvasElement
]

{ #category : #dependencies }
SpToploRoassalAdapter >> release [
	self class instVarNames do: [ :n | self instVarNamed: n put: nil ]
]

{ #category : #factory }
SpToploRoassalAdapter >> updateBlocElement [

	widget removeChildren.

	widget addChild: model canvas host canvasElement
]
