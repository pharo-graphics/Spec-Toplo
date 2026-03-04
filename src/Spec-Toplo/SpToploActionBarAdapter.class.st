"
I'm a Spec adapter for `SpActionBarPresenter`.
"
Class {
	#name : #SpToploActionBarAdapter,
	#superclass : #SpToploToolbarAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #initialization }
SpToploActionBarAdapter >> subscribeToPresenter [

	"super subscribeToPresenter."
]

{ #category : #'updating widget' }
SpToploActionBarAdapter >> updateItems [

	widget removeAllItems.

	(model items at: #start) do: [ :each |
		widget addItem: (self newItemFor: each) ].
	widget addFiller.
	model items at: #end ifPresent: [ :ends |
		ends do: [ :each | widget addItem: (self newItemFor: each) ] ]
]
