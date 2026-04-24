Trait {
	#name : #SpToploTWithEmbeddedListItem,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'instance creation' }
SpToploTWithEmbeddedListItem >> newItemElementFor: anItem [
	"Build a list item from the presenter factory used by SpListViewPresenter and SpTreeListViewPresenter."

	| contentPresenter toElement |
	contentPresenter := self model setupAction value: self model.
	self model bindAction value: contentPresenter value: anItem.

	toElement := contentPresenter build.
	toElement userData at: #specModel put: anItem.

	^ self prepareEmbeddedItemPanesIn: toElement
]

{ #category : #private }
SpToploTWithEmbeddedListItem >> prepareEmbeddedItemPanesIn: aBlElement [

	(aBlElement isKindOf: ToPane) ifTrue: [
			aBlElement background: BlBackground transparent.
			aBlElement addEventHandlerOn: ToInstallSkinEvent do: [ :event | event currentTarget background: BlBackground transparent ] ].
	aBlElement childrenDo: [ :child | self prepareEmbeddedItemPanesIn: child ].
	^ aBlElement 
]
