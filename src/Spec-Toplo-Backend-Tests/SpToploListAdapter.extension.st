Extension { #name : #SpToploListAdapter }

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploListAdapter >> typeForSearch: aString [
	"Method for testing
	equivalent to typeByChar: of SpToploAbstractTextAdapter"

	widget requestFocus.
	widget eventSimulator textInput: aString
]
