Class {
	#name : #SpToploStatusBarAdapter,
	#superclass : #SpToploWidgetAdapter,
	#instVars : [
		'pushedMessages'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploStatusBarAdapter >> buildWidget [

	^ ToLabel new
]

{ #category : #initialization }
SpToploStatusBarAdapter >> initialize [ 

	super initialize.
	pushedMessages := OrderedCollection new
]
