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
		subscribeToPresenter;
		subscribeToWidget
]

{ #category : #testing }
SpToploAdapter >> isVisible [
	
	^ widget isVisible
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

{ #category : #'updating widget' }
SpToploAdapter >> updateVisible [

	widget visibility:
		(model isVisible
			ifTrue: [ BlVisibility visible ]
			ifFalse: [ BlVisibility hidden ])
]
