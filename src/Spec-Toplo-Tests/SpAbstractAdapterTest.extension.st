Extension { #name : 'SpAbstractAdapterTest' }

{ #category : '*Spec-Toplo-Tests' }
SpAbstractAdapterTest class >> testParameters [ 

	^ ParametrizedTestMatrix new
		forSelector: #specInitializationStrategy
			addOptions: { [ SpInitializationStrategy beforeTest ]. [ SpInitializationStrategy afterTest ] };
		forSelector: #backendForTest
			addOptions: { SpToploBackendForTest };
		yourself
]
