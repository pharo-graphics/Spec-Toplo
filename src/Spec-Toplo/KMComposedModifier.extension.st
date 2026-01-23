Extension { #name : #KMComposedModifier }

{ #category : #'*Spec-Toplo' }
KMComposedModifier >> applyOnBlKeyCombinationBuilder: aBlKeyCombinationBuilder [

	self modifiers do: [ :modifier |
		modifier applyOnBlKeyCombinationBuilder: aBlKeyCombinationBuilder ]
]
