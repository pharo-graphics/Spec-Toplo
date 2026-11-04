"
I'm an abstract Spec adapter for all presenters.
"
Class {
	#name : #SpToploAdapter,
	#superclass : #SpAbstractAdapter,
	#instVars : [
		'eventHandlersBySubscriber'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #accessing }
SpToploAdapter class >> adaptingName [
	"Override me if adapter will not follow the common pattern"

	^ (self name withoutPrefix: 'SpToplo') asSymbol
]

{ #category : #accessing }
SpToploAdapter class >> allAdapters [
	"The abstract adapters should be able to return all the adapters for a framework"
	
	^ self allSubclasses
]

{ #category : #initialization }
SpToploAdapter >> adapt: aPresenter [

	super adapt: aPresenter.

	self adaptToploWidget
]

{ #category : #initialization }
SpToploAdapter >> adaptToploWidget [
	"Initialize and bind the widget to the model"

	self
		updateLayout;
		updateAll;
		addShortcuts;
		subscribeToPresenter;
		subscribeToWidget
]

{ #category : #initialization }
SpToploAdapter >> addShortcuts [

	model contextKeyBindings ifNotNil: [ :aCategory | 
		aCategory allEntries keymaps do: [ :each |
			self
				bindKeyCombination: each shortcut 
				toAction: each action ] ]
]

{ #category : #adding }
SpToploAdapter >> addStyle: aString [
	"Ignore style and just apply it again (the new style will not there).
	
	Inspired on SpAbstractMorphicAdapter>>#addStyle:"

	self updateStyle
]

{ #category : #accessing }
SpToploAdapter >> backend [

	^ model application backend
]

{ #category : #compatibility }
SpToploAdapter >> bindKeyCombination: aKMKeyCombination toAction: aBlock [

	widget addShortcut: 
		(BlShortcutWithAction new
			 combination: (aKMKeyCombination acceptVisitor: SpToploKMVisitor new);
			 action: aBlock;
			 yourself).
]

{ #category : #'deferred message' }
SpToploAdapter >> defer: aBlockClosure [
	"Enqueue aBlockClosure in the space, which will be valued in next #pulse."

	widget enqueueTask: (BlTaskAction new
		 action: aBlockClosure;
		 yourself)
]

{ #category : #accessing }
SpToploAdapter >> eventHandlersBySubscriber [

	^ eventHandlersBySubscriber
]

{ #category : #initialization }
SpToploAdapter >> initialize [

	super initialize.
	eventHandlersBySubscriber := Dictionary new
]

{ #category : #testing }
SpToploAdapter >> isVisible [
	
	^ widget isVisible
]

{ #category : #accessing }
SpToploAdapter >> removeStyle: aString [ 
	"ignore style and just apply it again (the removed style will not be there).
	
	Inspired on: SpAbstractMorphicAdapter>>#removeStyle:"

	self updateStyle
]

{ #category : #initialization }
SpToploAdapter >> subscribeToPresenter [
	"Subscribe to the presenter so the widget updates on every change announcement."

	model whenVisibleChangedDo: [ self updateVisible ]
]

{ #category : #initialization }
SpToploAdapter >> subscribeToWidget [
	"Subscribe to certain widget events that require to trigger actions in the presenter (model).

	Important: avoid cycles in announcements that would produce an infinite loop."

]

{ #category : #protocol }
SpToploAdapter >> takeKeyboardFocus [

	widget requestFocus
]

{ #category : #releasing }
SpToploAdapter >> unsubscribe [

	self
		unsubscribeFromWidget;
		unsubscribeFromPresenter.
	super unsubscribe
]

{ #category : #events }
SpToploAdapter >> unsubscribe: aSubscriber [

	| handlers |
	handlers := eventHandlersBySubscriber removeKey: aSubscriber ifAbsent: [ ^ self ].
	self widgetDo: [ :aWidget |
		handlers do: [ :eachHandler |
			aWidget removeEventHandler: eachHandler ] ]
]

{ #category : #initialization }
SpToploAdapter >> unsubscribeFromPresenter [

	model ifNotNil: [ :aPresenter |
		aPresenter hasAnnouncer ifTrue: [
			self widgetDo: [ :aWidget |
				aPresenter announcer unsubscribe: aWidget ].
			aPresenter announcer unsubscribe: self ] ]
]

{ #category : #initialization }
SpToploAdapter >> unsubscribeFromWidget [

	self widgetDo: [ :aWidget |
		eventHandlersBySubscriber valuesDo: [ :handlers |
			handlers do: [ :eachHandler |
				aWidget removeEventHandler: eachHandler ] ] ].
	eventHandlersBySubscriber removeAll
]

{ #category : #initialization }
SpToploAdapter >> updateAll [
	"Apply all the presenter specifications to the backend widget.
	
	Expected to be sent during widget creation."

	self updateVisible
]

{ #category : #initialization }
SpToploAdapter >> updateLayout [

	widget matchParent
]

{ #category : #adding }
SpToploAdapter >> updateStyle [

	self flag: #todo
]

{ #category : #'updating widget' }
SpToploAdapter >> updateVisible [

	widget visibility:
		(model isVisible
			ifTrue: [ BlVisibility visible ]
			ifFalse: [ BlVisibility gone ])
]

{ #category : #events }
SpToploAdapter >> when: anEventClass do: aBlock for: aSubscriber [

	| handler handlers |
	handler := BlEventHandler on: anEventClass do: aBlock.
	self widgetDo: [ :aWidget | aWidget addEventHandler: handler ].
	handlers := eventHandlersBySubscriber
		at: aSubscriber
		ifAbsentPut: [ OrderedCollection new ].
	handlers add: handler.
	^ handler
]

{ #category : #accessing }
SpToploAdapter >> widgetElement [

	^ widget
]

{ #category : #accessing }
SpToploAdapter >> widgetSpace [

	^ widget space
]
