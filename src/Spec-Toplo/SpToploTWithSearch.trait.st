"
I wire the search of a searchable Spec presenter (see SpTSearchable) to the type-ahead of a Toplo list element.
"
Trait {
	#name : #SpToploTWithSearch,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #accessing }
SpToploTWithSearch >> searchListElement [
	"The list element that receives keystrokes"

	^ self widget
]

{ #category : #updating }
SpToploTWithSearch >> updateSearch [

	self model isSearchEnabled
		ifTrue: [ self searchListElement typeAheadMatcher: [ :item :pattern | self model performSearch: item matching: pattern ] ]
		ifFalse: [ self searchListElement disableTypeAhead ]
]
