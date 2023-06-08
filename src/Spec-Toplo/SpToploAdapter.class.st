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

{ #category : #initialization }
SpToploAdapter >> adapt: aPresenter [

	super adapt: aPresenter.

	self
		updateAll;
		subscribeToPresenter;
		subscribeToWidget.

]

{ #category : #initialization }
SpToploAdapter >> subscribeToPresenter [
	"Subscribe to the presenter so the widget updates on every change announcement."

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

]
