"
I check that the Spec style classes of a presenter become prefixed Toplo stamps (style 'code' gives stamp #'spec-code') on the widget of its adapter. Presenters are only built, never opened.
"
Class {
	#name : #SpToploStyleTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #running }
SpToploStyleTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #tests }
SpToploStyleTest >> testRemoveStyleRemovesStamp [

	| label |
	label := (SpLabelPresenter newApplication: application)
		         addStyle: 'code';
		         yourself.
	label build.
	label removeStyle: 'code'.
	self deny: (label adapter widget hasStamp: #'spec-code')
]

{ #category : #tests }
SpToploStyleTest >> testStyleAddedAfterBuildIsStamped [

	| label |
	label := SpLabelPresenter newApplication: application.
	label build.
	label addStyle: 'code'.
	self assert: (label adapter widget hasStamp: #'spec-code')
]

{ #category : #tests }
SpToploStyleTest >> testStyleAddedBeforeBuildIsStamped [

	| label |
	label := (SpLabelPresenter newApplication: application)
		         addStyle: 'code';
		         yourself.
	label build.
	self assert: (label adapter widget hasStamp: #'spec-code')
]

{ #category : #tests }
SpToploStyleTest >> testStyleOnLayoutPresenterIsStamped [

	| presenter |
	presenter := SpPresenter newApplication: application.
	presenter
		layout: (SpBoxLayout newTopToBottom
				 add: presenter newLabel;
				 yourself);
		addStyle: 'panel'.
	presenter build.
	self assert: (presenter adapter widget hasStamp: #'spec-panel')
]
