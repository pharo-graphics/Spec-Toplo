"
I'm a Spec adapter for `SpComponentListPresenter`.
"
Class {
	#name : #SpToploComponentListAdapter,
	#superclass : #SpToploAbstractListAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #accessing }
SpToploComponentListAdapter >> children [
	"The list items are presenters: answer the widgets built for them."

	^ self widget dataAccessor collect: [ :itemPresenter | itemPresenter adapter widget ]
]

{ #category : #'instance creation' }
SpToploComponentListAdapter >> newItemElementFor: itemPresenter [

	^ itemPresenter build
]

{ #category : #protocol }
SpToploComponentListAdapter >> takeKeyboardFocus [

	self flag: #toImplement
]
