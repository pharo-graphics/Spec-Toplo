"
I am an event handler that can be added to a `ToTextField` to make it behave like a typical password input field.
"
Class {
	#name : #SpToploPlainTextFieldEventHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'adapter'
	],
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #accessing }
SpToploPlainTextFieldEventHandler >> adapter: aSpToploTextAdapter [

	adapter := aSpToploTextAdapter
]

{ #category : #'api - accessing' }
SpToploPlainTextFieldEventHandler >> eventsToHandle [

	^ {  AlbTextEditedEvent.
		  AlbTextReplacedEvent }
]

{ #category : #'event handling' }
SpToploPlainTextFieldEventHandler >> textEditedEvent: evt [

	adapter setPresenterText: evt text
]

{ #category : #'event handling' }
SpToploPlainTextFieldEventHandler >> textReplacedEvent: evt [

	adapter setPresenterText: evt text
]
