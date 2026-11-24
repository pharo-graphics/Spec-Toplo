"
I am an abstract superclass for Spec-Toplo adapter tests that run against a Toplo SpApplication managed by SpToploBackendForTest.
"
Class {
	#name : #SpToploAbstractAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'backend'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #testing }
SpToploAbstractAdapterTest class >> isAbstract [

	^ self == SpToploAbstractAdapterTest
]

{ #category : #running }
SpToploAbstractAdapterTest >> runCase [

	SpPresenter disableExtentRememberingDuring: [
		backend := SpToploBackendForTest new.
		backend runTestWithApplication: [ :testApplication |
			application := testApplication.
			super runCase ] ]
]

{ #category : #helpers }
SpToploAbstractAdapterTest >> waitUntilUIRedrawed [

	backend waitUntilUIRedrawed
]
