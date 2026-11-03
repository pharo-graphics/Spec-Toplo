Extension { #name : #SpToploTreeColumnViewAdapter }

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploTreeColumnViewAdapter >> expandRowAt: anInteger [
	"Expand the row at the index in the tree, as a click on its expand arrow does."

	(self widget dataSource at: anInteger) expand
]

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploTreeColumnViewAdapter >> isRowMorphExpandableAt: anInteger [

	(self model application propertyAt: #testBackend) waitUntilUIRedrawed.
	^ (((self widget list nodeContainers at: anInteger) childWithId: #'start-container') childWithId: #arrowButton)
		  childWithId: #unknown
		  ifFound: [ ^ false ]
		  ifNone: [ ^ true ]
]
