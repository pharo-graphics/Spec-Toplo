"
I'm a Spec adapter for `SpWindowPresenter`.
"
Class {
	#name : #SpToploWindowAdapter,
	#superclass : #SpToploAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploWindowAdapter >> addPresenterIn: aBlSpace withSpecLayout: aSpExecutableLayout [ 

	self presenter initialExtent 
		ifNotNil: [ :extent | widget extent: extent ].

	self updateContentWithSpecLayout: aSpExecutableLayout
]

{ #category : #factory }
SpToploWindowAdapter >> buildWidget [

	^ BlSpace new
]

{ #category : #'deferred message' }
SpToploWindowAdapter >> defer: aBlockClosure [
	"Enqueue aBlockClosure in the space, which will be valued in next #pulse."

	self widget enqueueTask: (BlTaskAction new
		 action: aBlockClosure;
		 yourself)
]

{ #category : #'submorphs - add/remove' }
SpToploWindowAdapter >> delete [
	
	self widgetDo: [ :w |
		w close.
		model application windowClosed: self ]
]

{ #category : #'instance creation' }
SpToploWindowAdapter >> open [
	"Enqueue opening the window after next universe pulse. 
	See #onSpaceShown for posterior initialization."

	widget show
]

{ #category : #'instance creation' }
SpToploWindowAdapter >> openSync [
	"Open a space. When this method returns, the space is opened (or an error ocurred)."

	| aSemaphore |
	aSemaphore := Semaphore new.
	widget
		when: BlSpaceShownEvent
		doOnce: [ :event | aSemaphore signal ].

	widget show.

	"Wait until the space in actually opened by the host universe process."
	aSemaphore wait: 1 second
]

{ #category : #protocol }
SpToploWindowAdapter >> openWithDeferredAction: aBlockClosure [ 

	self open.
	self defer: aBlockClosure
]

{ #category : #accessing }
SpToploWindowAdapter >> title: aString [

	widget title: aString
]

{ #category : #updating }
SpToploWindowAdapter >> updateContentWithSpecLayout: aSpExecutableLayout [
	"Build the presenter of the window, and establish the Toplo widget as content of the window."

	widget root
		removeChildren;
		addChild: (self presenter presenter buildWithLayout: aSpExecutableLayout)
]

{ #category : #initialization }
SpToploWindowAdapter >> updateLayout [
	"Do nothing on the `BlSpace`."
]

{ #category : #updating }
SpToploWindowAdapter >> updateVisible [

	model isVisible
		ifTrue: [ widget show ]
		ifFalse: [ widget close ]
]
