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
	"The choice combination is converted into an alternative combination"

	| keyCombination convertedKeyCombination |
	keyCombination := Character space asKeyCombination | Character cr asKeyCombination.
	convertedKeyCombination := keyCombination acceptVisitor: SpToploKMVisitor new.

	self
		assert: convertedKeyCombination
		equals:
			(BlAlternativeCombination new
				key: KeyboardKey space;
				key: KeyboardKey enter;
				yourself)
]

{ #category : #tests }
SpToploKMVisitorTest >> testEnterThenSpace [
	"The sequence is converted into a compulsory combination"

	| keyCombination convertedKeyCombination |
	keyCombination := Character space asKeyCombination, Character cr asKeyCombination.
	convertedKeyCombination := keyCombination acceptVisitor: SpToploKMVisitor new.

	self
		assert: convertedKeyCombination
		equals:
			(BlCompulsoryCombination new
				key: KeyboardKey space;
				key: KeyboardKey enter;
				yourself)
]

{ #category : #tests }
SpToploKMVisitorTest >> testEscape [

	| keyCombination convertedKeyCombination |
	keyCombination := KeyboardKey escape asKeyCombination.
	convertedKeyCombination := keyCombination acceptVisitor: SpToploKMVisitor new.

	self
		assert: convertedKeyCombination
		equals:
			(BlSingleKeyCombination new
				key: KeyboardKey escape;
				yourself)
]

{ #category : #tests }
SpToploKMVisitorTest >> testShiftA [

	| keyCombination convertedKeyCombination |
	keyCombination := KeyboardKey A shift.
	convertedKeyCombination := keyCombination acceptVisitor: SpToploKMVisitor new.

	self
		assert: convertedKeyCombination
		equals:
			(BlCompulsoryCombination new
				with: 
					(BlAlternativeCombination new
						key: KeyboardKey shiftLeft;
						key: KeyboardKey shiftRight;
						yourself);
				key: KeyboardKey A;
				yourself)
]
