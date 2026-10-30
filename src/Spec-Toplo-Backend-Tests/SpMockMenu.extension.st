Extension { #name : #SpMockMenu }

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpMockMenu >> items [
	"The Toplo backend fills its context menu with the items of the built menu
	(see SpToploTWithContextMenu>>#fillContextMenu:), right before popping it up.
	This is the Toplo equivalent of #popUpEvent:in: in the Morphic backend."

	self shown: true.
	^ realMenu items
]
