"
I'm an abstract Spec adapter for all text widgets.
"
Class {
	#name : #SpToploAbstractTextAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #accessing }
SpToploAbstractTextAdapter >> placeHolderText [

	^ widget userData at: #specPlaceholder ifAbsent: [ nil ]
]

{ #category : #'api - selection' }
SpToploAbstractTextAdapter >> selectAll [
	
	widget selecter all select
]

{ #category : #'new selection' }
SpToploAbstractTextAdapter >> selectLine [

	widget selecter
		extendToWholeLine;
		select
]

{ #category : #accessing }
SpToploAbstractTextAdapter >> selection [
	
	| selection |
	selection := widget selection.
	^ selection firstIndex to: selection to
]

{ #category : #initialization }
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

{ #category : #initialization }
SpToploAbstractTextAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	"Note: We don't subscribe with whenSelectionChangedDo: because the
	presenter directly sends messages to this adapter when selection changes."

	model
		whenTextChangedDo: [ self updateText ];
		whenPlaceholderChangedDo: [ self updatePlaceholder ];
		whenEditableChangedDo: [ self updateEditable ]
]

{ #category : #accessing }
SpToploAbstractTextAdapter >> text: aString [ 
	
	widget text: aString asRopedText
]

{ #category : #simulating }
SpToploAbstractTextAdapter >> typeByChar: aString [ 
	
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

{ #category : #initialization }
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

	widget text asString = model text ifTrue: [ ^ self ].

	widget text: model text
]
