Class {
	#name : #SpToploTreeListViewAdapter,
	#superclass : #SpToploTreeAdapter,
	#traits : 'SpToploTWithEmbeddedListItem',
	#classTraits : 'SpToploTWithEmbeddedListItem classTrait',
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #protocol }
SpToploTreeListViewAdapter >> takeKeyboardFocus [
	self widget requestFocus
]
