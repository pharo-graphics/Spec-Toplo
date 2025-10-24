"
I'm a Spec adapter for `SpStatusBarPresenter`.
"
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

{ #category : #updating }
SpToploStatusBarAdapter >> popMessage [

	| message |
	pushedMessages ifEmpty: [ ^ self ].
	pushedMessages removeLast.
	message := pushedMessages
		ifNotEmpty: [ :ps | ps last ]
		ifEmpty: [ '' ].
	widget text: message asRopedText
]

{ #category : #updating }
SpToploStatusBarAdapter >> update: aSymbol [ 
	"Based on SpMorphicStatusBarAdapter>>update:"

	aSymbol = #pushMessage ifTrue: [ self updateMessage ].
	aSymbol = #popMessage ifTrue: [ self popMessage ].

	^ super update: aSymbol
]

{ #category : #updating }
SpToploStatusBarAdapter >> updateAll [

	super updateAll.

	self updateMessage
]

{ #category : #updating }
SpToploStatusBarAdapter >> updateMessage [
.
	model message ifNotNil: [ :message |
		pushedMessages add: message.
		widget text: message asRopedText ]
]
