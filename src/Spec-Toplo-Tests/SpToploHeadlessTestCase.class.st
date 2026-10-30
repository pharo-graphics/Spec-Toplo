"
I am an abstract test case for tests that open Spec presenters with the Toplo backend.

I run each test through a SpToploBackendForTest (see #performTest): the test is executed on the Bloc headless host, below the Bloc pulse loop priority, and every window opened during the test is closed afterwards. No real OS window is ever opened.

`application` is the Toplo application created by the backend for the current test. It is only available while the test runs (it is nil in #setUp and #tearDown, which run outside #performTest), so presenters must be created and opened from the test methods.

Subclasses can override #closeNonWindowPresenters to release things opened during the test that are not window presenters (e.g. popovers), before the backend closes the windows.
"
Class {
	#name : #SpToploHeadlessTestCase,
	#superclass : #TestCase,
	#instVars : [
		'backend',
		'application'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #testing }
SpToploHeadlessTestCase class >> isAbstract [

	^ self == SpToploHeadlessTestCase
]

{ #category : #running }
SpToploHeadlessTestCase >> closeNonWindowPresenters [
	"Hook. Close what the test opened that is not a window presenter (the backend only closes window presenters).
	Called at the end of the test, still on the headless host, before the backend closes the windows."

	
]

{ #category : #running }
SpToploHeadlessTestCase >> performTest [

	backend runTest: [
			application := backend app.
			[ super performTest ] ensure: [ self closeNonWindowPresenters ] ]
]

{ #category : #running }
SpToploHeadlessTestCase >> setUp [

	super setUp.
	backend := SpToploBackendForTest new
]

{ #category : #running }
SpToploHeadlessTestCase >> waitUntilUIRedrawed [

	backend waitUntilUIRedrawed
]
