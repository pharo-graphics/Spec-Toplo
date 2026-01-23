"
I'm a Spec adapter for `SpListPresenter`.
"
Class {
	#name : #SpToploListViewAdapter,
	#superclass : #SpToploAbstractListAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'instance creation' }
SpToploListViewAdapter >> newItemElementFor: anItem [
	"Answer a new `BlElement` to represent the received item. In the case of the SpListPresenter, the item is one of the objects set in the collection via `SpAbstractListPresenter>>#items:` (so, it's not a wrapper)."

	| contentPresenter toElement |
	contentPresenter := self model setupAction value: self model.

	self model bindAction value: contentPresenter value: anItem.

	toElement := contentPresenter build.
	toElement userData at: #specModel put: anItem.

	^ toElement
]
