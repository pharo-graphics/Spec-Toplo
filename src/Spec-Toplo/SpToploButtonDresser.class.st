"
I'm a dresser for `SpToploButton`.
"
Class {
	#name : #SpToploButtonDresser,
	#superclass : #ToGeneralButtonDresser,
	#instVars : [
		'enabledHandler',
		'disabledHandler'
	],
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #private }
SpToploButtonDresser >> applyEnabledTo: aToGeneralButton [

	aToGeneralButton labelElement text foreground: (aToGeneralButton isEnabled
		ifTrue: [ theme button defaultTextColor ]
		ifFalse: [ theme button disabledTextColor ])
]

{ #category : #'api - install/uninstall  hook' }
SpToploButtonDresser >> installEventListenersIn: anElement [

	super installEventListenersIn: anElement.

	anElement labelElement whenTextReplacedDo: [
		self applyEnabledTo: anElement ].

	enabledHandler := BlEventHandler
		on: ToWidgetEnabledEvent
		do: [ :event | self applyEnabledTo: anElement ].
	disabledHandler := BlEventHandler
		on: ToWidgetDisabledEvent
		do: [ :event | self applyEnabledTo: anElement ].
	anElement addEventHandler: enabledHandler.
	anElement addEventHandler: disabledHandler
]

{ #category : #'api - install/uninstall  hook' }
SpToploButtonDresser >> uninstallEventListenersIn: anElement [

	super uninstallEventListenersIn: anElement.
	anElement removeEventHandler: enabledHandler.
	anElement removeEventHandler: disabledHandler
]
