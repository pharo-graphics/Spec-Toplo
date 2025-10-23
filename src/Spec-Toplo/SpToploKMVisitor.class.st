"
I convert instances of `KMKeyCombination` to instances of `BlKeyCombination`.
"
Class {
	#name : #SpToploKMVisitor,
	#superclass : #Object,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #visiting }
SpToploKMVisitor >> visitCombinationShortcut: aKMKeyCombinationSequence [

	| combination |
	combination := BlCompulsoryCombination new.

	aKMKeyCombinationSequence sequence do: [ :each |
		combination with: (each acceptVisitor: self) ].

	^ combination
]

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

	self flag: #todo. "Should double-dispatch, but KM doesn't provide it"

	^ aKMKeyCombination class = KMSingleKeyCombination
		ifTrue: [ BlSingleKeyCombination key: aKMKeyCombination key ]
		ifFalse: [
			aKMKeyCombination class = KMModifiedKeyCombination
				ifTrue: [
					| builder |
					builder := BlKeyCombination builder.
					aKMKeyCombination modifier applyOnBlKeyCombinationBuilder: builder.
					builder key: aKMKeyCombination key.
					builder build ]
				ifFalse: [
					aKMKeyCombination class = KMKeyCombinationChoice
						ifTrue: [
							self visitKeyCombinationChoice: aKMKeyCombination ]
						ifFalse: [
							self error: #todo ] ] ]
]
