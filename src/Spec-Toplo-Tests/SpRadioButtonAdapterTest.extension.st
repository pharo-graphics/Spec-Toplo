Extension { #name : 'SpRadioButtonAdapterTest' }

{ #category : '*Spec-Toplo-Tests' }
SpRadioButtonAdapterTest >> testChangingLabelAffectTheWidget [
	
	presenter label: 'ALabel'.
	self assert: self adapter label equals: 'ALabel'
]
