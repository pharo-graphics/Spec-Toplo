Extension { #name : #SpToploCodeAdapter }

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploCodeAdapter >> hasSyntaxHighlightEnabled [

	^ self widget styler isKindOf: BlPharoCodeStyler
]
