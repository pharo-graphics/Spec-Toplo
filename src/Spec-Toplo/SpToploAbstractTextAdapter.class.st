"
I'm an abstract Spec adapter for all text widgets.
"
Class {
	#name : #SpToploAbstractTextAdapter,
	#superclass : #SpToploWidgetAdapter,
	#instVars : [
		'listenTextChanges',
		'eventHandler'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> bindKeyCombination: aKMKeyCombination toAction: aBlock [

	widget editor addEditorShortcut: 
		(BlShortcutWithAction new
			 combination: (aKMKeyCombination acceptVisitor: SpToploKMVisitor new);
			 action: aBlock;
			 yourself).
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> cursorPositionIndex: anInteger [
	"Set the cursor position to the received integer >= 1."

	"Note: Album considers first position is 0."
	widget cursor position: anInteger - 1
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> getText [
	
	^ widget text asString
]

{ #category : #initialization }
SpToploAbstractTextAdapter >> initialize [

	super initialize.
	
	eventHandler :=
		self newTextEventHandler
			adapter: self;
			yourself
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> keyDown: keyCharacter shift: shiftBoolean meta: metaBoolean control: controlBoolean option: optionBoolean [

	| timestamp input key modifiers events |
	timestamp := widget space time now.

	input := OrderedCollection new.

	shiftBoolean ifTrue: [ 
		self notYetImplemented ].
	metaBoolean ifTrue: [
		input add: KeyboardKey metaLeft ].
	controlBoolean ifTrue: [ 
		self notYetImplemented ].
	optionBoolean ifTrue: [ 
		self notYetImplemented ].

	key := KeyboardKey fromCharacter: keyCharacter.
	modifiers :=
		BlKeyModifiers
			shift: shiftBoolean
			ctrl: controlBoolean
			alt: optionBoolean
			cmd: metaBoolean.

	events := Array streamContents: [ :stream |
		input do: [ :eachKey |
			stream nextPut:
				((BlKeyDownEvent target: widget)
					key: eachKey;
					scanCode: nil;
					timestamp: timestamp;
					yourself) ].

			stream
				nextPut: ((BlKeyDownEvent target: widget)
					key: key;
					modifiers: modifiers;
					timestamp: timestamp;
					scanCode: nil;
					yourself);
				nextPut: ((BlKeyDownEvent target: widget)
					key: key;
					modifiers: modifiers;
					timestamp: timestamp;
					scanCode: nil;
					yourself).

		input reverseDo: [ :eachKey |
			stream nextPut:
				((BlKeyUpEvent target: widget)
					key: eachKey;
					timestamp: timestamp;
					scanCode: nil;
					yourself) ] ].

	widget requestFocus.
	BlSpace simulateEvents: events on: widget
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> lineAtCursorPosition [

	| start end |
	start := widget navigator findTextIndexAtLineStart: widget cursor.
	end := widget navigator findTextIndexAtLineEnd: widget cursor.
	^ (widget text from: start + 1 to: end) asString
]

{ #category : #initialization }
SpToploAbstractTextAdapter >> newTextEventHandler [

	^ SpToploPlainTextFieldEventHandler new
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> pendingText [

	^ self getText
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> placeHolderText [

	^ widget userData at: #specPlaceholder ifAbsent: [ nil ]
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> selectAll [
	
	widget selecter all select
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> selectLine [

	widget selecter
		extendToWholeLine;
		select
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> selection [

	| selection |
	selection := widget selection.

	^ selection
		ifEmpty: [ #() ]
		ifNotEmpty: [ selection firstIndex to: selection to ]
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> selectionInterval [

	^ self selection
]

{ #category : #initialization }
SpToploAbstractTextAdapter >> setPresenterText: aBlText [

	eventHandler suspendEventHandlingDuring: [
		model text: aBlText asString ]
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> setSelectionFromModel: anInterval [

	| aSelecter |
	aSelecter := widget selecter.
	aSelecter overwrite.

	anInterval isEmpty ifFalse: [
		aSelecter
			from: anInterval first - 1
			to: anInterval last ].

	aSelecter select
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> setWidgetString: aString [

	widget selecter
		all;
		apply.
	widget inserter
		atEnd;
		string: aString;
		apply
]

{ #category : #initialization }
SpToploAbstractTextAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	"Note: We don't subscribe with whenSelectionChangedDo: because the
	presenter directly sends messages to this adapter when selection changes."

	model
		whenTextChangedDo: [ :newText | eventHandler presenterChanged: newText ];
		whenPlaceholderChangedDo: [ self updatePlaceholder ];
		whenEditableChangedDo: [ self updateEditable ]
]

{ #category : #initialization }
SpToploAbstractTextAdapter >> subscribeToWidget [

	super subscribeToWidget.

	widget addEventHandler: eventHandler
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> text: aString [

	self setWidgetString: aString
]

{ #category : #'accessing widget' }
SpToploAbstractTextAdapter >> typeByChar: aString [ 
	
	widget requestFocus.
	BlSpace simulateTextInput: aString on: widget
]

{ #category : #initialization }
SpToploAbstractTextAdapter >> updateAll [

	super updateAll.
	
	self
		updateText;
		updatePlaceholder;
		updateSelection;
		updateEditable
]

{ #category : #'updating widget' }
SpToploAbstractTextAdapter >> updateEditable [

	model isEditable
		ifTrue: [ widget beEditable ]
		ifFalse: [ widget beReadonlyWithSelection ]
]

{ #category : #'updating widget' }
SpToploAbstractTextAdapter >> updatePlaceholder [

	widget userData at: #specPlaceholder put: model placeholder.
	widget placeholderText: model placeholder
]

{ #category : #initialization }
SpToploAbstractTextAdapter >> updateSelection [

	self setSelectionFromModel: model selectionInterval
]

{ #category : #'updating widget' }
SpToploAbstractTextAdapter >> updateText [

	{ #updateText. widget text asString. model text. widget text asString = model text } traceCr.

	widget text asString = model text ifTrue: [ ^ self ].

	widget text: model text
]
