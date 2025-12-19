Class {
	#name : #SpToploDiffAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploDiffAdapter >> buildWidget [

	^ ToDiffElement new
		  from: self leftText
		  to: self rightText
		  contextClass: self contextClass;
		  yourself
]

{ #category : #factory }
SpToploDiffAdapter >> contextClass [

	^ self model contextClass
]

{ #category : #factory }
SpToploDiffAdapter >> leftText [

	^ self model leftText
]

{ #category : #factory }
SpToploDiffAdapter >> rightText [

	^ self model rightText
]
