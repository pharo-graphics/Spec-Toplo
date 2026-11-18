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
	"widget toFront"

	self flag: 
		#'toImplement - seem to have missing stuff in BlOSWindowSDL2HostSpace'
]

{ #category : #activation }
SpToploWindowAdapter >> isDisplayed [

	^ widget isVisible
]

{ #category : #testing }
SpToploWindowAdapter >> isTopWindow [

	^ widget isFocused
]

{ #category : #hook }
SpToploWindowAdapter >> newRootElement [

	^ SpToploWindowElement new
]

{ #category : #'window management' }
SpToploWindowAdapter >> restore [

	widget show
]

{ #category : #accessing }
SpToploWindowAdapter >> widgetSpace [

	^ widget
]
