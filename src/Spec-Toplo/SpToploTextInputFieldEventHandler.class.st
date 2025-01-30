"
I am an event handler that can be added to a `ToTextField` to make it behave like a typical password input field.
"
Class {
	#name : #SpToploTextInputFieldEventHandler,
	#superclass : #SpToploAbstractTextEventHandler,
	#instVars : [
		'textField',
		'isPassword',
		'text'
	],
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #private }
SpToploTextInputFieldEventHandler >> bePassword: aBoolean [ 

	isPassword = aBoolean ifTrue: [ ^self ].

	isPassword := aBoolean.

	self suspendEventHandlingDuring: [
		| cursorPosition |
		cursorPosition := textField cursor position.
		adapter setWidgetString:
			(isPassword
				ifTrue: [ self textAsAsterisks ]
				ifFalse: [ text ]).
		textField cursor position: cursorPosition ]
]

{ #category : #'api - accessing' }
SpToploTextInputFieldEventHandler >> eventsToHandle [

	^ {  AlbTextInsertedEvent.
		  AlbTextDeletedEvent.
		  AlbTextReplacedEvent }
]

{ #category : #initialization }
SpToploTextInputFieldEventHandler >> initialize [

	super initialize.
	
	isPassword := false
]

{ #category : #accessing }
SpToploTextInputFieldEventHandler >> isPassword [

	^ isPassword
]

{ #category : #accessing }
SpToploTextInputFieldEventHandler >> isSuspended [
	
	^ isSuspended
]

{ #category : #'api - hooks' }
SpToploTextInputFieldEventHandler >> onInstalledIn: aToTextField [

	super onInstalledIn: aToTextField.

	textField := aToTextField.
	text := aToTextField text copy
]

{ #category : #accessing }
SpToploTextInputFieldEventHandler >> passwordAsAsterisks [

	^ String new: text size withAll: $*
]

{ #category : #'event handling' }
SpToploTextInputFieldEventHandler >> setPresenterText [

	adapter setPresenterText: text
]

{ #category : #accessing }
SpToploTextInputFieldEventHandler >> text [

	^ text
]

{ #category : #accessing }
SpToploTextInputFieldEventHandler >> textAsAsterisks [

	^ String new: text size withAll: $*
]

{ #category : #'event handling' }
SpToploTextInputFieldEventHandler >> textDeletedEvent: evt [

	isSuspended ifTrue: [ ^ self ].

	text delete: evt fromIndex to: evt toIndex.
	self setPresenterText.

	isPassword ifTrue: [
		self updateWidgetWithAsterisks ].
	
	evt target cursor position: evt fromIndex - 1
]

{ #category : #'event handling' }
SpToploTextInputFieldEventHandler >> textInsertedEvent: evt [ 

	| cursorPosition |
	isSuspended ifTrue: [ ^ self ].

	cursorPosition := evt target cursor position.
	
	text insertText: evt text at: evt index.
	self setPresenterText.
	
	isPassword ifTrue: [
		self updateWidgetWithAsterisks ].
	
	evt target cursor position: cursorPosition.
]

{ #category : #'event handling' }
SpToploTextInputFieldEventHandler >> textReplacedEvent: evt [

	isSuspended ifTrue: [ ^ self ].
	
	text := evt text copy.

	self
		updateWidgetWithAsterisks;
		setPresenterText
]

{ #category : #private }
SpToploTextInputFieldEventHandler >> updateWidgetWithAsterisks [

	adapter setWidgetString: self textAsAsterisks
]
