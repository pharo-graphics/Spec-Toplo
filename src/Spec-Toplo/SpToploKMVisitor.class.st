Class {
	#name : #SpToploKMVisitor,
	#superclass : #Object,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #visiting }
SpToploKMVisitor >> visitSingleShortcut: aKMKeyCombination [

	| builder |
	builder := BlKeyCombination builder.
	
	aKMKeyCombination modifier class = KMMetaModifier
		ifTrue: [ builder meta ]
		ifFalse: [ self notYetImplemented ].
	
	builder key: aKMKeyCombination key.
	
	^ builder build 
]
