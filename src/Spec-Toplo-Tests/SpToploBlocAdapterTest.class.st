"
A SpToploBlocAdapterTest is a test class for testing the behavior of SpToploBlocAdapter.
"
Class {
	#name : #SpToploBlocAdapterTest,
	#superclass : #SpToploAbstractAdapterTest,
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #tests }
SpToploBlocAdapterTest >> testClickEventOnBlocElement [

	| presenter element clicked |
	clicked := false.
	element :=
		BlElement new
			extent: 100 @ 50;
			addEventHandlerOn: BlClickEvent do: [ :anEvent | clicked := true ];
			yourself.
	presenter := application instantiate: SpBlocPresenter.
	presenter blocElement: element.
	presenter open.
	self waitUntilUIRedrawed.
	self deny: clicked.

	element eventSimulator click.
	self assert: clicked
]

{ #category : #tests }
SpToploBlocAdapterTest >> testOpenWithBlocElement [

	| presenter element |
	element := BlElement new extent: 100 @ 50; yourself.
	presenter := application instantiate: SpBlocPresenter.
	presenter blocElement: element.
	presenter open.
	self waitUntilUIRedrawed.

	self assert: presenter adapter class equals: SpToploBlocAdapter.
	self assert: presenter adapter widget class equals: ToElement.
	self assert: element isAttachedToSceneGraph.
	self assert: element parent equals: presenter adapter widget.
	self assert: presenter adapter widget children size equals: 1.
	self assert: element extent equals: 100 @ 50
]

{ #category : #tests }
SpToploBlocAdapterTest >> testReplaceAndClearBlocElement [

	| presenter firstElement secondElement widget |
	firstElement := BlElement new extent: 100 @ 50; yourself.
	secondElement := BlElement new extent: 120 @ 60; yourself.
	presenter := application instantiate: SpBlocPresenter.
	presenter blocElement: firstElement.
	presenter open.
	self waitUntilUIRedrawed.
	widget := presenter adapter widget.
	self assert: firstElement isAttachedToSceneGraph.
	self assert: widget children size equals: 1.
	self assert: widget children first equals: firstElement.

	presenter blocElement: secondElement.
	self waitUntilUIRedrawed.
	self deny: firstElement isAttachedToSceneGraph.
	self deny: firstElement hasParent.
	self assert: secondElement isAttachedToSceneGraph.
	self assert: secondElement parent equals: widget.
	self assert: widget children size equals: 1.
	self assert: secondElement extent equals: 120 @ 60.

	presenter blocElement: nil.
	self waitUntilUIRedrawed.
	self deny: secondElement isAttachedToSceneGraph.
	self deny: secondElement hasParent.
	self assert: widget children isEmpty
]

{ #category : #tests }
SpToploBlocAdapterTest >> testSetBlocElementAfterOpen [

	| presenter element |
	presenter := application instantiate: SpBlocPresenter.
	presenter open.
	self waitUntilUIRedrawed.
	self assert: presenter adapter class equals: SpToploBlocAdapter.
	self assert: presenter adapter widget children isEmpty.

	element := BlElement new extent: 80 @ 40; yourself.
	presenter blocElement: element.
	self waitUntilUIRedrawed.
	self assert: element isAttachedToSceneGraph.
	self assert: element parent equals: presenter adapter widget.
	self assert: presenter adapter widget children size equals: 1.
	self assert: element extent equals: 80 @ 40
]

{ #category : #tests }
SpToploBlocAdapterTest >> testUnsubscribeStopsUpdatingWidget [

	| presenter firstElement secondElement adapter |
	firstElement := BlElement new.
	secondElement := BlElement new.
	presenter := application instantiate: SpBlocPresenter.
	presenter blocElement: firstElement.
	presenter build.
	adapter := presenter adapter.
	self assert: adapter widget children size equals: 1.
	self assert: adapter widget children first equals: firstElement.

	adapter unsubscribe.
	presenter blocElement: secondElement.
	self assert: adapter widget children size equals: 1.
	self assert: adapter widget children first equals: firstElement.
	self deny: secondElement hasParent
]

{ #category : #tests }
SpToploBlocAdapterTest >> testWidgetMatchesParentInPanedLayout [

	| container presenter element widget |
	element := BlElement new extent: 100 @ 50; yourself.
	presenter := application instantiate: SpBlocPresenter.
	presenter blocElement: element.
	container := application instantiate: SpPresenter.
	container layout:
		(SpPanedLayout newLeftToRight
			add: SpNullPresenter new;
			add: presenter;
			yourself).
	container open.
	self waitUntilUIRedrawed.

	widget := presenter adapter widget.
	self assert: widget constraints horizontal resizer isMatchParent.
	self assert: widget constraints vertical resizer isMatchParent.
	self assert: widget width > 0.
	self assert: widget height > 0
]
