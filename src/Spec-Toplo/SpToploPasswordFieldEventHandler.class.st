"
I am an event handler that can be added to a `ToTextField` to make it behave like a typical password input field.
"
Class {
	#name : #SpToploPasswordFieldEventHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'textField',
		'password',
		'adapter'
	],
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #'api - hooks' }
SpToploPasswordFieldEventHandler >> adapter: aSpToploTextAdapter [

	adapter := aSpToploTextAdapter
]

{ #category : #'api - accessing' }
SpToploPasswordFieldEventHandler >> eventsToHandle [

	^ {  AlbTextInsertedEvent.
		  AlbTextDeletedEvent.
		  AlbTextReplacedEvent }
]

{ #category : #'api - hooks' }
SpToploPasswordFieldEventHandler >> onInstalledIn: aToTextField [

	super onInstalledIn: aToTextField.

	password := aToTextField text copy.
	textField := aToTextField.

	self updateWidgetWithAsterisks
]

{ #category : #'api - hooks' }
SpToploPasswordFieldEventHandler >> onUninstalledIn: aToTextField [

	super onUninstalledIn: aToTextField.

	adapter setWidgetString: password asString
]

{ #category : #accessing }
SpToploPasswordFieldEventHandler >> password [

	^ password
]

{ #category : #accessing }
SpToploPasswordFieldEventHandler >> passwordAsAsterisks [

	^ String new: password size withAll: $*
]

{ #category : #'event handling' }
SpToploPasswordFieldEventHandler >> textDeletedEvent: evt [

	password delete: evt fromIndex to: evt toIndex.

	self
		updateWidgetWithAsterisks;
		updatePresenterText.

	evt target cursor position: evt fromIndex - 1
]

{ #category : #'event handling' }
SpToploPasswordFieldEventHandler >> textInsertedEvent: evt [ 

	| cursorPosition |
	password insertText: evt text at: evt index.

	cursorPosition := evt target cursor position.

	self
		updateWidgetWithAsterisks;
		updatePresenterText.

	evt target cursor position: cursorPosition
]

{ #category : #'event handling' }
SpToploPasswordFieldEventHandler >> textReplacedEvent: evt [

	password
		deleteAll;
		insertText: evt text at: 0.

	self
		updateWidgetWithAsterisks;
		updatePresenterText
]

{ #category : #'event handling' }
SpToploPasswordFieldEventHandler >> updatePresenterText [

	adapter setPresenterText: password
]

{ #category : #private }
SpToploPasswordFieldEventHandler >> updateWidgetWithAsterisks [

	adapter setWidgetString: self passwordAsAsterisks
]
