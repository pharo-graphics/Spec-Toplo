Class {
	#name : #SpToMiniBrowserEditorModel,
	#superclass : #Object,
	#instVars : [
		'selectedBehavior',
		'selectedMethod',
		'whenSelectedBehaviorChangedBlock',
		'whenSelectedMethodChangedBlock'
	],
	#category : #'Spec-Toplo-Examples-MiniBrowser-Presenters'
}

{ #category : #accessing }
SpToMiniBrowserEditorModel >> selectedBehavior [

	^ selectedBehavior
]

{ #category : #accessing }
SpToMiniBrowserEditorModel >> selectedBehavior: anObject [

	selectedBehavior = anObject ifTrue: [ ^ self ].
	selectedBehavior := anObject.
	whenSelectedBehaviorChangedBlock ifNotNil: [ :block | block cull: selectedBehavior ]
]

{ #category : #accessing }
SpToMiniBrowserEditorModel >> selectedMethod [

	^ selectedMethod
]

{ #category : #accessing }
SpToMiniBrowserEditorModel >> selectedMethod: anObject [

	selectedMethod = anObject ifTrue: [ ^ self ].
	selectedMethod := anObject.
	whenSelectedMethodChangedBlock ifNotNil: [ :block | block cull: selectedMethod ]
]

{ #category : #accessing }
SpToMiniBrowserEditorModel >> whenSelectedBehaviorChangedDo: aBlock [

	whenSelectedBehaviorChangedBlock := aBlock 
]

{ #category : #accessing }
SpToMiniBrowserEditorModel >> whenSelectedMethodChangedDo: aBlock [

	whenSelectedMethodChangedBlock := aBlock 
]
