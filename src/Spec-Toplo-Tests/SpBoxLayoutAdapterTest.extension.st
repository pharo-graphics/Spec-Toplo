Extension { #name : #SpBoxLayoutAdapterTest }

{ #category : #'*Spec-Toplo-Tests' }
SpBoxLayoutAdapterTest >> testReplaceElementAppliesStyle [
	| p1 toReplace p2 replacement |
	
	layout add: (p1 := SpLabelPresenter new).
	layout add: (toReplace := SpLabelPresenter new).
	layout add: (p2 := SpLabelPresenter new).
	self openInstance.
	
	replacement := SpLabelPresenter new.
	replacement addStyle: 'code'. "code assigns code fonts"
	layout replace: toReplace with: replacement.
	
	self assert: self adapter children size equals: 3.
	self 
		assert: replacement adapter font
		equals: StandardFonts codeFont
]

{ #category : #'*Spec-Toplo-Tests' }
SpBoxLayoutAdapterTest >> testReplaceElementBeforeOpenAppliesStyle [
	| p1 toReplace p2 replacement |
	
	layout add: (p1 := SpLabelPresenter new).
	layout add: (toReplace := SpLabelPresenter new).
	layout add: (p2 := SpLabelPresenter new).
	
	replacement := SpLabelPresenter new.
	replacement addStyle: 'code'. "code assigns code fonts"
	layout replace: toReplace with: replacement.

	self openInstance.
	
	self assert: self adapter children size equals: 3.
	self 
		assert: replacement adapter font
		equals: StandardFonts codeFont
]
