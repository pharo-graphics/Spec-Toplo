"
I'm a Spec backend for Bloc.
"
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

{ #category : #'deferred message' }
SpToploBackend >> defer: aBlockClosure [
	"Enqueue aBlockClosure from any process to be executed in the UI process at the beginning of the next pulse."

	BlHost preferableHostClass universe defer: aBlockClosure
]

{ #category : #accessing }
SpToploBackend >> dropListClass [

	^ SpDropListPresenter
]

{ #category : #accessing }
SpToploBackend >> listClass [

	^ SpListPresenter
]

{ #category : #accessing }
SpToploBackend >> tableClass [

	^ SpTablePresenter
]

{ #category : #accessing }
SpToploBackend >> treeClass [

	^ SpTreePresenter
]
