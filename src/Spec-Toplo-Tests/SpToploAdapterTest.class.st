Class {
	#name : #SpToploAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #private }
SpToploAdapterTest >> performTest [

	SpToploBackendForTest new runTestWithApplication: [ :testApplication |
		application := testApplication.
		super performTest ]
]

{ #category : #tests }
SpToploAdapterTest >> testAdapterInstallsShortcutsFromActions [

	| presenter group shortcut buffer |
	group := CmCommandGroup new asSpecGroup.
	group register:
		(SpAction new
			name: 'Test';
			shortcutKey: $p meta;
			action: [ ];
			yourself).

	presenter := application instantiate: SpTablePresenter.
	presenter actions: group.
	presenter build.

	buffer := BlKeyboardBuffer new
		          add: (BlKeyDownEvent new key: KeyboardKey metaLeft);
		          add: (BlKeyDownEvent new key: KeyboardKey P);
		          yourself.
	shortcut := presenter adapter widget shortcuts detect: [ :s | s matches: buffer ] ifNone: [ nil ].
	self assert: shortcut isNotNil
]

{ #category : #tests }
SpToploAdapterTest >> testAdapterUnsubscribeRemovesSubscriptions [

	| presenter adapter |
	presenter := application instantiate: SpLabelPresenter.
	presenter build.
	adapter := presenter adapter.
	self denyEmpty: ((presenter observablePropertyNamed: #visible) instVarNamed: 'subscriptions').

	adapter unsubscribe.
	self assert: (((presenter observablePropertyNamed: #visible) instVarNamed: 'subscriptions') noneSatisfy: [ :sub | sub receiver == adapter ])
]

{ #category : #tests }
SpToploAdapterTest >> testAthensAdapterUnsubscribesFromWidget [

	| presenter adapter handler |
	presenter := application instantiate: SpAthensPresenter.
	presenter build.
	adapter := presenter adapter.
	handler := adapter widgetEventHandlers keys first.
	self assert: (adapter widget eventDispatcher hasHandler: handler).

	adapter unsubscribe.
	self deny: (adapter widget eventDispatcher hasHandler: handler).
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testCheckBoxAdapterUnsubscribesFromWidget [

	| presenter adapter handler |
	presenter := application instantiate: SpCheckBoxPresenter.
	presenter build.
	adapter := presenter adapter.
	handler := adapter widgetEventHandlers keys first.
	self assert: (adapter widget eventDispatcher hasHandler: handler).

	adapter unsubscribe.
	self deny: (adapter widget eventDispatcher hasHandler: handler).
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testCheckBoxAdapterUpdatesPresenterState [

	| presenter adapter |
	presenter := application instantiate: SpCheckBoxPresenter.
	presenter build.
	adapter := presenter adapter.
	self deny: presenter state.

	adapter widget checked: true.
	self assert: presenter state.

	adapter unsubscribe.
	adapter widget checked: false.
	self assert: presenter state
]

{ #category : #tests }
SpToploAdapterTest >> testCodeAdapterSubmitsActionOnSaveAccepted [

	| presenter adapter wasSubmitted |
	presenter := application instantiate: SpCodePresenter.
	wasSubmitted := false.
	presenter whenSubmitDo: [ :text | wasSubmitted := true ].
	presenter build.
	adapter := presenter adapter.
	adapter widget dispatchEvent: ToAlbumSaveAcceptedEvent new.
	self assert: wasSubmitted.

	wasSubmitted := false.
	adapter unsubscribe.
	adapter widget dispatchEvent: ToAlbumSaveAcceptedEvent new.
	self deny: wasSubmitted
]

{ #category : #tests }
SpToploAdapterTest >> testCodeAdapterUnsubscribesFromWidget [

	| presenter adapter handler |
	presenter := application instantiate: SpCodePresenter.
	presenter build.
	adapter := presenter adapter.
	handler := adapter widgetEventHandlers keys first.
	self assert: (adapter widget eventDispatcher hasHandler: handler).

	adapter unsubscribe.
	self deny: (adapter widget eventDispatcher hasHandler: handler).
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testColumnViewAdapterUnsubscribesFromWidget [

	| presenter adapter handlers |
	presenter := application instantiate: SpTablePresenter.
	presenter items: #( 'a' 'b' 'c' ).
	presenter addColumn: (SpStringTableColumn title: 'Col' evaluated: #asString).
	presenter build.
	adapter := presenter adapter.
	handlers := adapter widgetEventHandlers keys.
	self assert: handlers size equals: 2.
	handlers do: [ :each | self assert: (adapter widget list eventDispatcher hasHandler: each) ].

	adapter unsubscribe.
	handlers do: [ :each | self deny: (adapter widget list eventDispatcher hasHandler: each) ].
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testDropListAdapterUnsubscribesFromWidget [

	| presenter adapter handler |
	presenter := application instantiate: SpDropListPresenter.
	presenter items: #( 'item 1' 'item 2' ).
	presenter build.
	adapter := presenter adapter.
	handler := adapter widgetEventHandlers keys first.
	self assert: (adapter widget eventDispatcher hasHandler: handler).

	adapter unsubscribe.
	self deny: (adapter widget eventDispatcher hasHandler: handler).
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testDropListAdapterUpdatesPresenterSelection [

	| presenter adapter |
	presenter := application instantiate: SpDropListPresenter.
	presenter items: #( 'item 1' 'item 2' ).
	presenter build.
	adapter := presenter adapter.
	self assert: presenter selectedIndex equals: 1.

	adapter widget selecter selectIndex: 2.
	self assert: presenter selectedIndex equals: 2.

	adapter unsubscribe.
	adapter widget selecter selectIndex: 1.
	self assert: presenter selectedIndex equals: 2
]

{ #category : #tests }
SpToploAdapterTest >> testElementAdapterSubscribeToWidgetEvent [

	| presenter adapter wasCalled handler |
	presenter := application instantiate: SpLabelPresenter.
	presenter build.
	adapter := presenter adapter.
	wasCalled := false.
	handler := adapter subscribeToWidgetEvent: BlClickEvent do: [ wasCalled := true ].
	self assert: (adapter widgetEventHandlers includesKey: handler).
	self assert: (adapter widget eventDispatcher hasHandler: handler).

	adapter unsubscribe.
	self deny: (adapter widget eventDispatcher hasHandler: handler).
	self assertEmpty: adapter widgetEventHandlers
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
SpToploAdapterTest >> testListAdapterUnsubscribesFromWidget [

	| presenter adapter handlers |
	presenter := application instantiate: SpListPresenter.
	presenter items: #( 'a' 'b' 'c' ).
	presenter build.
	adapter := presenter adapter.
	handlers := adapter widgetEventHandlers keys.
	self assert: handlers size equals: 2.
	handlers do: [ :each | self assert: (adapter widget eventDispatcher hasHandler: each) ].

	adapter unsubscribe.
	handlers do: [ :each | self deny: (adapter widget eventDispatcher hasHandler: each) ].
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testMillerAdapterUnsubscribesFromWidget [

	| presenter window adapter handler spaceRoot |
	presenter := application instantiate: SpMillerColumnPresenter.
	window := presenter asWindow open.
	adapter := presenter adapter.
	window adapter widget host universe pulse.
	spaceRoot := adapter list space root.
	handler := adapter widgetEventHandlers keys first.
	self assert: (spaceRoot eventDispatcher hasHandler: handler).

	adapter unsubscribe.
	self deny: (spaceRoot eventDispatcher hasHandler: handler).
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testNotebookAdapterUnsubscribesFromWidget [

	| presenter adapter handler |
	presenter := application instantiate: SpNotebookPresenter.
	presenter addPage: (SpNotebookPage title: 'Page 1' provider: [ SpLabelPresenter new ]).
	presenter build.
	adapter := presenter adapter.
	handler := adapter widgetEventHandlers keys first.
	self assert: (adapter widget itemList eventDispatcher hasHandler: handler).

	adapter unsubscribe.
	self deny: (adapter widget itemList eventDispatcher hasHandler: handler).
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testPaginatorAdapterUnsubscribesFromWidget [

	| presenter adapter handler |
	presenter := application instantiate: SpPaginatorPresenter.
	presenter build.
	adapter := presenter adapter.
	handler := adapter widgetEventHandlers keys first.
	self assert: (adapter list eventDispatcher hasHandler: handler).

	adapter unsubscribe.
	self deny: (adapter list eventDispatcher hasHandler: handler).
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testRadioButtonAdapterUnsubscribesFromWidget [

	| presenter adapter handler |
	presenter := application instantiate: SpRadioButtonPresenter.
	presenter build.
	adapter := presenter adapter.
	handler := adapter widgetEventHandlers keys first.
	self assert: (adapter widget eventDispatcher hasHandler: handler).

	adapter unsubscribe.
	self deny: (adapter widget eventDispatcher hasHandler: handler).
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testRadioButtonAdapterUpdatesPresenterState [

	| presenter otherPresenter adapter |
	presenter := application instantiate: SpRadioButtonPresenter.
	otherPresenter := application instantiate: SpRadioButtonPresenter.
	presenter associatedRadioButtons: { otherPresenter }.
	otherPresenter state: true.
	presenter build.
	otherPresenter build.
	adapter := presenter adapter.
	self deny: presenter state.

	adapter widget checked: true.
	self assert: presenter state.

	adapter unsubscribe.
	adapter widget checked: false.
	self assert: presenter state
]

{ #category : #tests }
SpToploAdapterTest >> testToggleButtonAdapterUnsubscribesFromWidget [

	| presenter adapter handler |
	presenter := application instantiate: SpToggleButtonPresenter.
	presenter build.
	adapter := presenter adapter.
	handler := adapter widgetEventHandlers keys first.
	self assert: (adapter widget eventDispatcher hasHandler: handler).

	adapter unsubscribe.
	self deny: (adapter widget eventDispatcher hasHandler: handler).
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testToggleButtonAdapterUpdatesPresenterState [

	| presenter adapter |
	presenter := application instantiate: SpToggleButtonPresenter.
	presenter build.
	adapter := presenter adapter.
	self deny: presenter state.

	adapter widget checked: true.
	self assert: presenter state.

	adapter unsubscribe.
	adapter widget checked: false.
	self assert: presenter state
]

{ #category : #tests }
SpToploAdapterTest >> testTreeAdapterUnsubscribesFromWidget [

	| presenter adapter handlers |
	presenter := application instantiate: SpTreePresenter.
	presenter roots: #( 'root' ).
	presenter build.
	adapter := presenter adapter.
	handlers := adapter widgetEventHandlers keys.
	self assert: handlers size equals: 2.
	handlers do: [ :each | self assert: (adapter widget eventDispatcher hasHandler: each) ].

	adapter unsubscribe.
	handlers do: [ :each | self deny: (adapter widget eventDispatcher hasHandler: each) ].
	self assertEmpty: adapter widgetEventHandlers
]

{ #category : #tests }
SpToploAdapterTest >> testTreeColumnViewAdapterUnsubscribesFromWidget [

	| presenter adapter handlers |
	presenter := application instantiate: SpTreeTablePresenter.
	presenter roots: #( 'root' ).
	presenter addColumn: (SpStringTableColumn title: 'Col' evaluated: #asString).
	presenter build.
	adapter := presenter adapter.
	handlers := adapter widgetEventHandlers keys.
	self assert: handlers size equals: 2.
	handlers do: [ :each | self assert: (adapter widget list eventDispatcher hasHandler: each) ].

	adapter unsubscribe.
	handlers do: [ :each | self deny: (adapter widget list eventDispatcher hasHandler: each) ].
	self assertEmpty: adapter widgetEventHandlers
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

	| windowPresenter adapter handler |
	windowPresenter := (application instantiate: SpLabelPresenter) asWindow.
	windowPresenter open.
	adapter := windowPresenter adapter.
	handler := adapter subscribeToWidgetEvent: BlElementExtentChangedEvent on: adapter widget space do: [ :evt |  ].
	self assert: (adapter widgetEventHandlers includesKey: handler).
	self assert: (adapter widget space eventDispatcher hasHandler: handler).

	windowPresenter close.
	adapter widget host universe pulse.
	self deny: (adapter widget space eventDispatcher hasHandler: handler).
	self assertEmpty: adapter widgetEventHandlers
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
