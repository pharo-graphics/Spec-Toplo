"
I'm a Spec adapter for `SpWindowPresenter`.
"
Class {
	#name : #SpToploWindowAdapter,
	#superclass : #SpToploWindowLikeAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #activation }
SpToploWindowAdapter >> activate [
	"self widget toFront"

	self flag: 
		#'toImplement - seem to have missing stuff in BlOSWindowSDL2HostSpace'
]

{ #category : #activation }
SpToploWindowAdapter >> isDisplayed [

	^ self widget isVisible
]

{ #category : #testing }
SpToploWindowAdapter >> isTopWindow [

	^ self widget isFocused
]

{ #category : #hook }
SpToploWindowAdapter >> newRootElement [

	^ SpToploWindowElement new
]

{ #category : #'window management' }
SpToploWindowAdapter >> restore [

	self widget show
]

{ #category : #announcer }
SpToploWindowAdapter >> when: aClass do: aFullBlockClosure for: aMiModelsBrowser [

	self widget addEventHandlerOn: aClass do: aFullBlockClosure
]
