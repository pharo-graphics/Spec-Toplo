"
I'm a dresser for `SpToploLabel` that makes it respond to the enable/disable API.
"
Class {
	#name : #SpToploLabelDresser,
	#superclass : #ToLabelDresser,
	#instVars : [
		'enabledHandler',
		'disabledHandler'
	],
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #private }
SpToploLabelDresser >> applyForegroundTo: anElement [

	anElement text foreground: (anElement isEnabled
		ifTrue: [  theme button defaultTextColor ]
		ifFalse: [ theme button disabledTextColor ])
]

{ #category : #'api - install/uninstall  hook' }
SpToploLabelDresser >> installEventListenersIn: anElement [

	super installEventListenersIn: anElement.

	anElement whenTextReplacedDo: [
		self applyForegroundTo: anElement ].

	enabledHandler := BlEventHandler
		on: ToWidgetEnabledEvent
		do: [ :event | self applyForegroundTo: anElement ].
	disabledHandler := BlEventHandler
		on: ToWidgetDisabledEvent
		do: [ :event | self applyForegroundTo: anElement ].
	anElement addEventHandler: enabledHandler.
	anElement addEventHandler: disabledHandler
]

{ #category : #'api - install/uninstall  hook' }
SpToploLabelDresser >> uninstallEventListenersIn: anElement [

	super uninstallEventListenersIn: anElement.
	anElement removeEventHandler: enabledHandler.
	anElement removeEventHandler: disabledHandler
]
