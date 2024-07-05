"
I'm a Spec adapter for presenters that are adapter into a `BlSpace`.
"
Class {
	#name : #SpToploWindowLikeAdapter,
	#superclass : #SpToploAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #API }
SpToploWindowLikeAdapter >> addPresenterIn: aBlSpace withSpecLayout: aSpExecutableLayout [

	model initialExtent ifNotNil: [ :extent |
		widget extent: extent ].

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
"		  host: self blocHost;"
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

{ #category : #'deferred message' }
SpToploWindowLikeAdapter >> defer: aBlockClosure [
	"Enqueue aBlockClosure in the space, which will be valued in next #pulse."

	widget enqueueTask: (BlTaskAction new
		 action: aBlockClosure;
		 yourself)
]

{ #category : #'submorphs - add/remove' }
SpToploWindowLikeAdapter >> delete [
	
	self widgetDo: [ :w |
		w close.
		model application windowClosed: self ]
]

{ #category : #hook }
SpToploWindowLikeAdapter >> newRootElement [

	^ self subclassResponsibility
]

{ #category : #'event handling' }
SpToploWindowLikeAdapter >> onSpaceClosed [
	"Inspired on SpMorphicWindowAdapter>>#windowClosed"

	model
		windowIsClosing;
		windowClosed
]

{ #category : #'event handling' }
SpToploWindowLikeAdapter >> onSpaceShown [

	self defer: [
		"Setting window position was problematic before being showed."

		model initialPosition ifNotNil: [ :position |
			widget position: position ].
		model isCentered ifTrue: [ self centered ].

	"	model presenter takeKeyboardFocus."
		model windowIsOpening ]
]

{ #category : #API }
SpToploWindowLikeAdapter >> open [
	"Enqueue opening the window after next universe pulse. 
	See #onSpaceShown for posterior initialization."

	widget show
]

{ #category : #'instance creation' }
SpToploWindowLikeAdapter >> openSync [
	"Open a space. When this method returns, the space is opened (or an error ocurred)."

	| aSemaphore |
	aSemaphore := Semaphore new.
	widget when: BlSpaceShownEvent doOnce: [ :event | aSemaphore signal ].

	widget show.

	"Wait until the space in actually opened by the host universe process."
	aSemaphore wait: 1 second
]

{ #category : #protocol }
SpToploWindowLikeAdapter >> openWithDeferredAction: aBlockClosure [ 

	self open.
	self defer: aBlockClosure
]

{ #category : #'widget creation' }
SpToploWindowLikeAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model
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
		(model presenter buildWithLayout: aSpExecutableLayout)
]

{ #category : #accessing }
SpToploWindowLikeAdapter >> updateDecorationsAsBorderless [
	
	widget borderless: model hasDecorations not
]

{ #category : #initialization }
SpToploWindowLikeAdapter >> updateLayout [
	"Do nothing on the `BlSpace`."
]

{ #category : #'widget creation' }
SpToploWindowLikeAdapter >> updateMenu [

	model hasMenu ifFalse: [
		^ widget root removeMenu ].

	"Build new Toplo menu from presenter spec and set it."	
	widget root menu: model menu buildWithSpecAsPopup

]

{ #category : #'widget creation' }
SpToploWindowLikeAdapter >> updateStatusBar [

	"Inspired on SpAbstractMorphicWindowAdapter>>#addStatusBarTo:"

	model hasStatusBar ifFalse: [ ^ widget root removeStatusBar ].

	"Build new Toplo status bar from presenter spec and set it."
	widget root statusBar: model statusBar build
]

{ #category : #'widget creation' }
SpToploWindowLikeAdapter >> updateToolbar [

	"Inspired on SpAbstractMorphicWindowAdapter>>#setToolbarTo:"

	model hasToolbar ifFalse: [ ^ widget root removeToolbar ].

	"Build new Toplo toolbar from presenter spec and set it."
	widget root toolbar: model toolbar build
]

{ #category : #updating }
SpToploWindowLikeAdapter >> updateVisible [

	model isVisible
		ifTrue: [ widget show ]
		ifFalse: [ widget close ]
]
