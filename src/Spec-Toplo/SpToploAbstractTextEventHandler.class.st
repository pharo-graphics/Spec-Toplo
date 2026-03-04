"
I am an event handler that can be added to a `ToTextField`.
"
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

{ #category : #'event handling' }
SpToploAbstractTextEventHandler >> presenterChanged: aString [

	isSuspended ifTrue: [ ^ self ].

	adapter updateText
]

{ #category : #'event handling' }
SpToploAbstractTextEventHandler >> suspendEventHandlingDuring: aBlock [ 

	| oldState |
	oldState := isSuspended.
	isSuspended := true.
	aBlock ensure: [ isSuspended := oldState ]
]
