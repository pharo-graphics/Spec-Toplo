"
I'm a dresser for `SpToploLabel` that makes it respond to the enable/disable API.
"
Class {
	#name : #SpToploEnableableLabelDresser,
	#superclass : #ToEnableableDresser,
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #'api - install/uninstall  hook' }
SpToploEnableableLabelDresser >> applyForegroundTo: anElement [

	anElement text foreground: (anElement isEnabled
		ifTrue: [  theme button defaultTextColor ]
		ifFalse: [ theme button disabledTextColor ])
]

{ #category : #'api - install/uninstall  hook' }
SpToploEnableableLabelDresser >> disabledEvent: event on: anElement [

	self applyForegroundTo: anElement
]

{ #category : #'api - install/uninstall  hook' }
SpToploEnableableLabelDresser >> enabledEvent: event on: anElement [

	self applyForegroundTo: anElement
]

{ #category : #'api - install/uninstall  hook' }
SpToploEnableableLabelDresser >> installEventListenersIn: anElement [

	super installEventListenersIn: anElement.

	anElement whenTextReplacedDo: [
		self applyForegroundTo: anElement ]
]
