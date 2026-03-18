Class {
	#name : #SpToploSpinnerAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploSpinnerAdapter >> buildWidget [

	^ ToProgressCircle new
		  isInfinite: true;
		  yourself
]
