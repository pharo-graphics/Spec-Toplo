Class {
	#name : #SpToploScripts,
	#superclass : #Object,
	#category : #'Spec-Toplo-Tests'
}

{ #category : #'as yet unclassified' }
SpToploScripts class >> overrideAdapterTestToUseToploBackendAsOnlyOption [
	"For the moment, this is the nasty way to run Spec adapter tests, e.g. SpButtonAdapterTest.
	How to use?
	1. Execute this code.
	2. Open SUnit UI, search `SpButtonAdapterTest`
	3. Run it"
	<script>

	ParametrizedTestCase class compile: 'testParameters 

	^ ParametrizedTestMatrix new
		forSelector: #specInitializationStrategy
			addOptions: { [ SpInitializationStrategy beforeTest ]. [ SpInitializationStrategy afterTest ] };
		forSelector: #backendForTest
			addOptions: { SpToploBackendForTest };
		yourself'
]
