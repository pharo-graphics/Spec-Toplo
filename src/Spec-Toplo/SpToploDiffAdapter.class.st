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
		  leftLabel: self model leftLabel;
		  rightLabel: self model rightLabel;
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
SpToploDiffAdapter >> leftText: aLeftText [

	^ self widget srcText: aLeftText
]

{ #category : #factory }
SpToploDiffAdapter >> rightText [

	^ self model rightText
]

{ #category : #factory }
SpToploDiffAdapter >> rightText: aRightText [

	^ self widget targetText: aRightText
]
