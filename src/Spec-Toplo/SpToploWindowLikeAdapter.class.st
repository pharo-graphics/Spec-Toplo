Class {
	#name : #SpToploWindowLikeAdapter,
	#superclass : #SpToploAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #API }
SpToploWindowLikeAdapter >> addPresenterIn: aBlSpace withSpecLayout: aSpExecutableLayout [ 

	self presenter initialExtent 
		ifNotNil: [ :extent | widget extent: extent ].

	self
		updateMenu;
		updateToolbar;
		updateContentWithSpecLayout: aSpExecutableLayout;
		updateStatusBar

]

{ #category : #'widget creation' }
SpToploWindowLikeAdapter >> buildWidget [

	^ BlSpace new
		  root: self newRootElement;
		  host: self blocHost;
		  yourself
]

{ #category : #API }
SpToploWindowLikeAdapter >> centered [

	widget center
]

{ #category : #API }
SpToploWindowLikeAdapter >> centeredRelativeTo: aSpWindowPresenter [
	"Center the the window relative from another Bloc window. 
	The action is deferred becasue this method was sent from presenter during
	dialog initialization, when extent may not be set."

	self defer: [
		| referenceBlSpace deltaFromAnotherSpace |
		referenceBlSpace := aSpWindowPresenter adapter widget.

		deltaFromAnotherSpace :=
			(referenceBlSpace windowExtent - widget windowExtent) // 2.

		widget position: referenceBlSpace position + deltaFromAnotherSpace ]

]

{ #category : #API }
SpToploWindowLikeAdapter >> close [

	widget close
]

{ #category : #hook }
SpToploWindowLikeAdapter >> newRootElement [

	^ self subclassResponsibility
]

{ #category : #'event handling' }
SpToploWindowLikeAdapter >> onSpaceClosed [
	"Inspired on SpMorphicWindowAdapter>>#windowClosed"

	self presenter
		windowIsClosing;
		windowClosed
]

{ #category : #'event handling' }
SpToploWindowLikeAdapter >> onSpaceShown [

	self defer: [
		"Setting window position was problematic before being showed."

		self presenter initialPosition 
			ifNotNil: [ :position | widget position: position ].
		self presenter isCentered
			ifTrue: [ self centered ].

	"	self presenter presenter takeKeyboardFocus."
		self presenter windowIsOpening ].

]

{ #category : #API }
SpToploWindowLikeAdapter >> open [
	"Enqueue opening the window after next universe pulse. 
	See #onSpaceShown for posterior initialization."

	widget show
]

{ #category : #protocol }
SpToploWindowLikeAdapter >> openWithDeferredAction: aBlockClosure [ 

	self open.
	self defer: aBlockClosure
]

{ #category : #'widget creation' }
SpToploWindowLikeAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	self presenter
		whenDecorationsChangedDo: [ self updateDecorationsAsBorderless ];
		whenToolbarChangedDo: [ self updateToolbar ]

]

{ #category : #'widget creation' }
SpToploWindowLikeAdapter >> subscribeToWidget [

	widget
		addEventHandlerOn: BlSpaceClosedEvent do: [ self onSpaceClosed ];
		addEventHandlerOn: BlSpaceShownEvent do: [ self onSpaceShown ]
]

{ #category : #API }
SpToploWindowLikeAdapter >> title: aString [ 

	widget title: aString
]

{ #category : #accessing }
SpToploWindowLikeAdapter >> updateAll [
	"Important: this update is done BEFORE window's initializeWindow:"

	self updateDecorationsAsBorderless
]

{ #category : #accessing }
SpToploWindowLikeAdapter >> updateContentWithSpecLayout: aSpExecutableLayout [

	"Build the presenter of the window, and establish the Toplo widget as content of the window."

	widget root content:
		(self presenter presenter buildWithLayout: aSpExecutableLayout)
]

{ #category : #accessing }
SpToploWindowLikeAdapter >> updateDecorationsAsBorderless [
	
	widget borderless: self presenter hasDecorations not
]

{ #category : #'widget creation' }
SpToploWindowLikeAdapter >> updateMenu [

	self presenter hasMenu ifFalse: [
		^ widget root removeMenu ].

	"Build new Toplo menu from presenter spec and set it."	
	widget root menu: self presenter menu buildWithSpec

]

{ #category : #'widget creation' }
SpToploWindowLikeAdapter >> updateStatusBar [

	"Inspired on SpAbstractMorphicWindowAdapter>>#addStatusBarTo:"

	self presenter hasStatusBar ifFalse: [ ^ widget root removeStatusBar ].

	"Build new Toplo status bar from presenter spec and set it."
	widget root statusBar: self presenter statusBar build
]

{ #category : #'widget creation' }
SpToploWindowLikeAdapter >> updateToolbar [

	"Inspired on SpAbstractMorphicWindowAdapter>>#setToolbarTo:"

	self presenter hasToolbar ifFalse: [ ^ widget root removeToolbar ].

	"Build new Toplo toolbar from presenter spec and set it."
	widget root toolbar: self presenter toolbar build
]
