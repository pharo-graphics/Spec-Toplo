Class {
	#name : #SpToploTreeTableAdapter,
	#superclass : #SpToploTreeColumnViewAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTreeTableAdapter >> buildWidget [

	super buildWidget.
	widget nodeManager lazilyComputeChildren: model shouldLazilyComputeChildren.
	^ widget
]
