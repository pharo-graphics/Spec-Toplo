"
I'm a Spec adapter for `SpWindowPresenter`.
"
Class {
	#name : #SpToploWindowAdapter,
	#superclass : #SpToploWindowLikeAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #testing }
SpToploWindowAdapter >> isTopWindow [

	^ self widget isFocused
]

{ #category : #hook }
SpToploWindowAdapter >> newRootElement [

	^ SpToploWindowElement new
]

{ #category : #announcer }
SpToploWindowAdapter >> when: aClass do: aFullBlockClosure for: aMiModelsBrowser [

	self widget addEventHandlerOn: aClass do: aFullBlockClosure
]
