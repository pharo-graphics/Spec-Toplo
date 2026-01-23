"
I'm a Spec adapter for `SpListPresenter`.
"
Class {
	#name : #SpToploListAdapter,
	#superclass : #SpToploAbstractListAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'instance creation' }
SpToploListAdapter >> newItemElementFor: anItem [
	"Answer a new `BlElement` to represent the received item. In the case of the SpListPresenter, the item is one of the objects set in the collection via `SpAbstractListPresenter>>#items:` (so, it's not a wrapper)."

	| labeledIcon |
	labeledIcon := ToLabeledIcon new
		               startInterspace: 10;
		               hMatchParent;
		               yourself.

	model hasIcons ifTrue: [
		labeledIcon iconImage: (model iconFor: anItem) ].

	labeledIcon labelText: (model displayValueFor: anItem) asRopedText.

	^ labeledIcon
]

{ #category : #initialization }
SpToploListAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenIconsChangedDo: [ self refreshWidgetList ]
]
