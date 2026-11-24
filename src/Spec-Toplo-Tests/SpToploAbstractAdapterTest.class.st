"
I am an abstract superclass for Spec-Toplo adapter tests that run against a Toplo SpApplication managed by SpToploBackendForTest.
"
Class {
	#name : #SpToploAbstractAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
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
		SpToploBackendForTest new runTestWithApplication: [ :testApplication |
			application := testApplication.
			super runCase ] ]
]
