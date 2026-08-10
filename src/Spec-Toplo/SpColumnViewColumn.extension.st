Extension { #name : #SpColumnViewColumn }

{ #category : #'*Spec-Toplo' }
SpColumnViewColumn >> acceptColumnVisitor: aSpToploColumnViewAdapter [ 
	^ aSpToploColumnViewAdapter visitColumnViewColumn: self
]
