Class {
	#name : #SpToploActionBarAdapter,
	#superclass : #SpToploToolbarAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'updating widget' }
SpToploActionBarAdapter >> subscribeToPresenter [

	"super subscribeToPresenter."
]

{ #category : #'updating widget' }
SpToploActionBarAdapter >> updateItems [

	widget removeAllItems.

	(model items at: #start) do: [ :each |
		widget addItem: (self newItemFor: each) ].
	widget addFiller.
	(model items at: #end) do: [ :each |
		widget addItem: (self newItemFor: each) ]
]
