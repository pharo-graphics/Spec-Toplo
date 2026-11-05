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
SpToploAdapterTest >> testAdapterUnsubscribeRemovesSubscriptions [

	| presenter adapter |
	presenter := application instantiate: SpLabelPresenter.
	presenter build.
	adapter := presenter adapter.
	self assert: ((presenter observablePropertyNamed: #visible) instVarNamed: 'subscriptions') isNotEmpty.

	adapter unsubscribe.
	self assert: (((presenter observablePropertyNamed: #visible) instVarNamed: 'subscriptions') noneSatisfy: [ :sub | sub receiver == adapter ])
]

{ #category : #tests }
SpToploAdapterTest >> testElementAdapterWhenDoForSubscriberCanUnsubscribe [

	| presenter adapter subscriber wasCalled handler |
	presenter := application instantiate: SpLabelPresenter.
	presenter build.
	adapter := presenter adapter.
	subscriber := Object new.
	wasCalled := false.
	adapter
		when: BlClickEvent
		do: [ wasCalled := true ]
		for: subscriber.
	handler := (adapter eventHandlersBySubscriber at: subscriber) first.
	self assert: (adapter eventHandlersBySubscriber includesKey: subscriber).
	self assert: (adapter widget eventDispatcher hasHandler: handler).

	adapter unsubscribe: subscriber.
	self deny: (adapter eventHandlersBySubscriber includesKey: subscriber).
	self deny: (adapter widget eventDispatcher hasHandler: handler)
]

{ #category : #tests }
SpToploAdapterTest >> testLayoutAdapterUnsubscribeRemovesLayoutSubscriptions [

	| presenter layout layoutAdapter |
	presenter := application instantiate: SpLabelPresenter.
	layout := SpBoxLayout newVertical.
	presenter layout: layout.
	presenter build.
	layoutAdapter := presenter adapter.
	self assert: layout announcer numberOfSubscriptions > 0.

	layoutAdapter unsubscribe.
	self assert: layout announcer numberOfSubscriptions equals: 0
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

{ #category : #tests }
SpToploAdapterTest >> testWindowAdapterUnsubscribesWhenSpaceClosed [

	| windowPresenter adapter subscriber handler |
	windowPresenter := (application instantiate: SpLabelPresenter) asWindow.
	windowPresenter open.
	adapter := windowPresenter adapter.
	subscriber := Object new.
	adapter when: BlElementExtentChangedEvent do: [ subscriber printString ] for: subscriber.
	handler := (adapter eventHandlersBySubscriber at: subscriber) first.
	self assert: (adapter widget eventDispatcher hasHandler: handler).

	windowPresenter close.
	adapter widget host universe pulse.
	self deny: (adapter widget eventDispatcher hasHandler: handler).
	self assert: adapter eventHandlersBySubscriber isEmpty
]

{ #category : #tests }
SpToploAdapterTest >> testWindowAdapterWhenDoForSubscriberCanUnsubscribe [

	| windowPresenter adapter subscriber wasCalled handler |
	windowPresenter := (application instantiate: SpLabelPresenter) asWindow.
	windowPresenter build.
	adapter := windowPresenter adapter.
	subscriber := Object new.
	wasCalled := false.
	adapter
		when: BlElementExtentChangedEvent
		do: [ wasCalled := true ]
		for: subscriber.
	handler := (adapter eventHandlersBySubscriber at: subscriber) first.
	self assert: (adapter eventHandlersBySubscriber includesKey: subscriber).
	self assert: (adapter widget eventDispatcher hasHandler: handler).

	adapter unsubscribe: subscriber.
	self deny: (adapter eventHandlersBySubscriber includesKey: subscriber).
	self deny: (adapter widget eventDispatcher hasHandler: handler)
]

{ #category : #tests }
SpToploAdapterTest >> testWindowCloseWorksImmediatelyAfterOpen [

	| windowPresenter adapter space |
	windowPresenter := (application instantiate: SpLabelPresenter) asWindow.
	windowPresenter open.
	adapter := windowPresenter adapter.
	space := adapter widget.
	self assert: windowPresenter isOpen.
	self deny: windowPresenter isClosed.
	self assert: (application windows includes: windowPresenter).

	windowPresenter close.
	space host universe pulse.
	self deny: windowPresenter isOpen.
	self assert: windowPresenter isClosed.
	self deny: (application windows includes: windowPresenter).
	self deny: space isOpened
]
