Class {
	#name : #SpToploAbstractTextEventHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'isSuspended',
		'adapter'
	],
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #accessing }
SpToploAbstractTextEventHandler >> adapter: aSpToploTextAdapter [

	adapter := aSpToploTextAdapter
]

{ #category : #initialization }
SpToploAbstractTextEventHandler >> initialize [

	super initialize.
	
	isSuspended := false
]

{ #category : #'as yet unclassified' }
SpToploAbstractTextEventHandler >> presenterChanged: aString [ 
	
	isSuspended ifTrue: [ ^self ].
	
	adapter updateText
]

{ #category : #'as yet unclassified' }
SpToploAbstractTextEventHandler >> suspendEventHandlingDuring: aBlock [ 

	| oldState |
	oldState := isSuspended.
	isSuspended := true.
	aBlock ensure: [ isSuspended := oldState ]
]
