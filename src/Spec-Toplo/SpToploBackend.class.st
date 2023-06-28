Class {
	#name : #SpToploBackend,
	#superclass : #SpApplicationBackend,
	#category : #'Spec-Toplo-Base'
}

{ #category : #accessing }
SpToploBackend class >> backendName [

	^ #Toplo
]

{ #category : #private }
SpToploBackend >> adapterBindingsClass [
	
	^ SpToploAdapterBindings
]

{ #category : #accessing }
SpToploBackend >> defaultConfigurationFor: aSpApplication [

	^ aSpApplication defaultConfigurationForToplo
]
