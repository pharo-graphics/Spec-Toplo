"
I am a link between the Spec-Toplo backend and the Spec-Toplo hierarchy of adapters.
"
Class {
	#name : #SpToploAdapterBindings,
	#superclass : #SpAdapterBindings,
	#category : #'Spec-Toplo-Base'
}

{ #category : #accessing }
SpToploAdapterBindings >> abstractAdapterClass [
	
	^ SpToploAdapter
]

{ #category : #accessing }
SpToploAdapterBindings >> useInnerWindowAdapter [
	
	bindings at: #WindowAdapter put: SpToploInnerWindowAdapter name
]
