"
I'm an abstract Spec adapter for all presenters.
"
Class {
	#name : #SpToploAdapter,
	#superclass : #SpAbstractAdapter,
	#instVars : [
		'widgetSubscriptions',
		'presenterSubscriptions'
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

{ #category : #initialization }
SpToploAdapter >> initialize [

	super initialize.

	widgetSubscriptions := IdentityDictionary new.
	presenterSubscriptions := IdentitySet new
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

{ #category : #events }
SpToploAdapter >> subscribeToWidgetEvent: aBlEventClass do: aBlock [

	^ self subscribeToWidgetEvent: aBlEventClass on: widget do: aBlock
]

{ #category : #events }
SpToploAdapter >> subscribeToWidgetEvent: aBlEventClass on: anElement do: aBlock [

	| handler |
	handler := BlEventHandler on: aBlEventClass do: aBlock.
	anElement addEventHandler: handler.
	widgetSubscriptions at: handler put: anElement.
	^ handler
]

{ #category : #accessing }
SpToploAdapter >> subscribedPresenters [

	^ presenterSubscriptions
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

{ #category : #initialization }
SpToploAdapter >> unsubscribeFromPresenter [

	self unsubscribeFromPresenters.

	model ifNotNil: [ :aPresenter |
		aPresenter hasAnnouncer ifTrue: [
			self widgetDo: [ :aWidget | aPresenter announcer unsubscribe: aWidget ].
			aPresenter announcer unsubscribe: self ] ]
]

{ #category : #initialization }
SpToploAdapter >> unsubscribeFromPresenters [

	presenterSubscriptions do: [ :eachPresenter | eachPresenter unsubscribe: self ].
	presenterSubscriptions removeAll
]

{ #category : #initialization }
SpToploAdapter >> unsubscribeFromWidget [

	widgetSubscriptions keysAndValuesDo: [ :handler :element |
		element removeEventHandler: handler ].

	widgetSubscriptions removeAll
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

{ #category : #accessing }
SpToploAdapter >> widgetElement [

	^ widget
]

{ #category : #accessing }
SpToploAdapter >> widgetEventHandlers [

	^ widgetSubscriptions
]

{ #category : #accessing }
SpToploAdapter >> widgetSpace [

	^ widget space
]
