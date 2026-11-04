Class {
	#name : #SpToploAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #running }
SpToploAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #running }
SpToploAdapterTest >> tearDown [

	application ifNotNil: [ application windows do: [ :each | each delete ] ].
	super tearDown
]

{ #category : #tests }
SpToploAdapterTest >> testWidgetElementOnElementAdapter [

	| labelPresenter |
	labelPresenter := application instantiate: SpLabelPresenter.
	labelPresenter build.
	self
		assert: labelPresenter adapter widgetElement
		identicalTo: labelPresenter adapter widget
]

{ #category : #tests }
SpToploAdapterTest >> testWidgetElementOnInnerWindowAdapter [

	| innerWindowPresenter |
	application adapterBindings useInnerWindowAdapter.
	innerWindowPresenter := (application instantiate: SpLabelPresenter) asWindow.
	innerWindowPresenter build.
	self
		assert: innerWindowPresenter adapter widgetElement
		identicalTo: innerWindowPresenter adapter widget.

	innerWindowPresenter open
]

{ #category : #tests }
SpToploAdapterTest >> testWidgetElementOnWindowAdapter [

	| windowPresenter |
	windowPresenter := (application instantiate: SpLabelPresenter) asWindow.
	windowPresenter build.
	self
		assert: windowPresenter adapter widgetElement
		identicalTo: windowPresenter adapter widget root.

	windowPresenter open.
	self assert: windowPresenter adapter widgetElement isAttachedToSceneGraph
]
