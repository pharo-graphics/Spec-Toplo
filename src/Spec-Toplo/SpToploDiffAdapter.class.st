"
I'm a Spec adapter for `SpDiffPresenter`.
"
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
		  leftLabel: model leftLabel;
		  rightLabel: model rightLabel;
		  yourself
]

{ #category : #factory }
SpToploDiffAdapter >> contextClass [

	^ model contextClass
]

{ #category : #factory }
SpToploDiffAdapter >> leftText [

	^ model leftText
]

{ #category : #factory }
SpToploDiffAdapter >> leftText: aLeftText [

	^ widget srcText: aLeftText
]

{ #category : #factory }
SpToploDiffAdapter >> rightText [

	^ model rightText
]

{ #category : #factory }
SpToploDiffAdapter >> rightText: aRightText [

	^ widget targetText: aRightText
]

{ #category : #factory }
SpToploDiffAdapter >> showOnlyDestination: aBoolean [

	widget showOnlyDestination: aBoolean
]

{ #category : #factory }
SpToploDiffAdapter >> showOnlySource: aBoolean [

	widget showOnlySource: aBoolean
]
