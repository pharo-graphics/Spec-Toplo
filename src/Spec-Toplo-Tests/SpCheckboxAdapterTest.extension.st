Extension { #name : #SpCheckboxAdapterTest }

{ #category : #'*Spec-Toplo-Tests' }
SpCheckboxAdapterTest >> testChangingLabelAffectTheWidget [
	
	presenter label: 'ALabel'.
	self assert: self adapter label equals: 'ALabel'
]
