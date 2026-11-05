Extension { #name : #ToElement }

{ #category : #'*Spec-Toplo' }
ToElement >> borderColor: aColor [
	"Morphic-like API used by the Spec backend tests: change the border paint, keep its width"

	self border: (self border copyWithPaint: aColor)
]
