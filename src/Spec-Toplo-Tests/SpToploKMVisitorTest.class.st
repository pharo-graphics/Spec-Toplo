"
A SpToploKMVisitorTest is a test class for testing the behavior of SpToploKMVisitor
"
Class {
	#name : #SpToploKMVisitorTest,
	#superclass : #TestCase,
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #tests }
SpToploKMVisitorTest >> testEnterOrSpace [

	| keyCombination |
	keyCombination := Character space asKeyCombination | Character cr asKeyCombination.
	keyCombination acceptVisitor: SpToploKMVisitor new.
	1halt
]
