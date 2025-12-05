Class {
	#name : #SpToploLinkAdapter,
	#superclass : #SpToploLabelAdapter,
	#instVars : [
		'styleSheet'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploLinkAdapter >> buildWidget [

	widget := super buildWidget.
	self setStyleSheet: widget.
	^ widget
]

{ #category : #factory }
SpToploLinkAdapter >> setStyleSheet: label [

	label addTokenNamed: #'color-text' withValue: self theme urlColor
]

{ #category : #initialization }
SpToploLinkAdapter >> subscribeToWidget [
	
	widget clickAction: self model action
]
