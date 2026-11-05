Extension { #name : #SpAbstractAdapterTest }

{ #category : #'*Spec-Toplo-Tests' }
SpAbstractAdapterTest >> backendInstanceForTest: aBackendForTest [

	backendForTest := aBackendForTest
]

{ #category : #'*Spec-Toplo-Tests' }
SpAbstractAdapterTest class >> testParameters [

	^ ParametrizedTestMatrix new
		forSelector: #specInitializationStrategy
			addOptions: {
				[ SpInitializationStrategy beforeTest ].
				[ SpInitializationStrategy afterTest ] };
		forSelector: #backendInstanceForTest
			addOptions: SpToploBackendForTest availableBackendsForTest;
		yourself
]
