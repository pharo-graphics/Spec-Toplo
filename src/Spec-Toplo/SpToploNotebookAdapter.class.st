Class {
	#name : #SpToploNotebookAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploNotebookAdapter >> buildWidget [

	^ ToTabPaneElement new
]
