"
I am an event handler that can be added to a `ToTextField` to make it behave like a typical password input field.
"
Class {
	#name : #SpToploPlainTextFieldEventHandler,
	#superclass : #SpToploAbstractTextEventHandler,
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #'api - accessing' }
SpToploPlainTextFieldEventHandler >> eventsToHandle [

	^ {  AlbTextEditedEvent.
		  AlbTextReplacedEvent }
]

{ #category : #'event handling' }
SpToploPlainTextFieldEventHandler >> textEditedEvent: evt [

	isSuspended ifTrue: [ ^ self ].

	{ #textEditedEvent:. evt text } traceCr.
	
	adapter setPresenterText: evt text
]

{ #category : #'event handling' }
SpToploPlainTextFieldEventHandler >> textReplacedEvent: evt [

	isSuspended ifTrue: [ ^ self ].

	{ #textReplacedEvent:. evt text } traceCr.

	adapter setPresenterText: evt text
]
