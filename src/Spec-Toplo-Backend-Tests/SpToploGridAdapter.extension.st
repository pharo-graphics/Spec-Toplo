Extension { #name : #SpToploGridAdapter }

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploGridAdapter >> extentOfChildAt: anInteger [

	^ (self children at: anInteger) bounds extent
]
