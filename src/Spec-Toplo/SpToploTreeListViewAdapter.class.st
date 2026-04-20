Class {
	#name : #SpToploTreeListViewAdapter,
	#superclass : #SpToploTreeAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTreeListViewAdapter >> newItemElementFor: anItem [
	| contentPresenter toElement |

	contentPresenter := self model setupAction value: self model.
	self model bindAction value: contentPresenter value: anItem.

	toElement := contentPresenter build.
	toElement userData at: #specModel put: anItem.
	toElement hMatchParent.

	^ toElement
]
