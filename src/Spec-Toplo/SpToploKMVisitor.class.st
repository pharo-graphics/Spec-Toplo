"
I convert instances of `KMKeyCombination` to instances of `BlKeyCombination`.
"
Class {
	#name : #SpToploKMVisitor,
	#superclass : #Object,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #visiting }
SpToploKMVisitor >> visitKeyCombinationChoice: aKMKeyCombination [

	| alternative |
	alternative := BlAlternativeCombination new.

	aKMKeyCombination combinationsDo: [ :each |
		alternative with: (each acceptVisitor: self) ].

	^ alternative
]

{ #category : #visiting }
SpToploKMVisitor >> visitSingleShortcut: aKMKeyCombination [

	^ aKMKeyCombination class = KMKeyCombinationChoice
		ifTrue: [ self visitKeyCombinationChoice: aKMKeyCombination ]
		ifFalse: [
			| builder |
			builder := BlKeyCombination builder.
			aKMKeyCombination modifier applyOnBlKeyCombinationBuilder: builder.
			builder key: aKMKeyCombination key.
			builder build ]
]
