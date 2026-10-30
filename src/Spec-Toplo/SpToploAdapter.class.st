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

{ #category : #styling }
SpToploAdapter class >> stampForStyle: aString [
	"Answer the Toplo stamp standing for the Spec style class aString.
	The prefix keeps Spec styles apart from the stamps used by Toplo themes, such as #default or #text."

	^ ('spec-' , aString) asSymbol
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
		updateStyle;
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
	"Stamp my element with the style class; Toplo re-skins it when its stamps change."

	self styledElement ifNotNil: [ :anElement | anElement addStamp: (self class stampForStyle: aString) ]
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

{ #category : #testing }
SpToploAdapter >> isVisible [
	
	^ widget isVisible
]

{ #category : #accessing }
SpToploAdapter >> removeStyle: aString [

	self styledElement ifNotNil: [ :anElement | anElement removeStamp: (self class stampForStyle: aString) ]
]

{ #category : #styling }
SpToploAdapter >> styledElement [
	"Answer the element that carries the stamps of the presenter styles, nil while the widget is not built."

	^ widget
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
	"Stamp my element with every style class of the presenter, including those added before it was built."

	self presenter styles do: [ :aString | self addStyle: aString ]
]

{ #category : #'updating widget' }
SpToploAdapter >> updateVisible [

	widget visibility:
		(model isVisible
			ifTrue: [ BlVisibility visible ]
			ifFalse: [ BlVisibility gone ])
]
