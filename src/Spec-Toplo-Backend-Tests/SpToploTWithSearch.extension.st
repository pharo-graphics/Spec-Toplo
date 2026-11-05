Extension { #name : #SpToploTWithSearch }

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploTWithSearch >> type: aString [

	self typeForSearch: aString
]

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploTWithSearch >> typeForSearch: aString [
	"Emulate typing to perform a search"

	self searchListElement requestFocus.
	self searchListElement eventSimulator textInput: aString
]
