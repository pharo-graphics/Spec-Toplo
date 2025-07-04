"
I'm an abstract Spec adapter for all presenters.
"
Class {
	#name : #SpToploAdapter,
	#superclass : #SpAbstractAdapter,
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

{ #category : #compatibility }
SpToploAdapter >> bindKeyCombination: aKMKeyCombination toAction: aBlock [

	self shouldBeImplemented.
]

{ #category : #'deferred message' }
SpToploAdapter >> defer: aBlockClosure [
	"Enqueue aBlockClosure in the space, which will be valued in next #pulse."

	widget enqueueTask: (BlTaskAction new
		 action: aBlockClosure;
		 yourself)
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
			ifFalse: [ BlVisibility hidden ])
]
