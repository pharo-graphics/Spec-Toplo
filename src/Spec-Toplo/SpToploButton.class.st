"
I'm a Toplo button that adds some particulatiries that Spec needs.

This is the case of enabled/disabled behavior, adaptation of icon with a form, and string instead of roped text.

"
Class {
	#name : #SpToploButton,
	#superclass : #ToGeneralButton,
	#instVars : [
		'imageElement',
		'labelElement'
	],
	#classVars : [
		'NullIcon'
	],
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #'class initialization' }
SpToploButton class >> initialize [

	NullIcon := Form extent: 0 asPoint
]

{ #category : #'t - initialization dresser' }
SpToploButton >> defaultDresser [

	^ SpToploButtonDresser new
]

{ #category : #accessing }
SpToploButton >> hasIcon [

	^ imageElement innerImage == NullIcon
]

{ #category : #accessing }
SpToploButton >> iconForm [
	
	^ self hasIcon
		ifTrue: [ nil ]
		ifFalse: [ imageElement innerImage ]
]

{ #category : #accessing }
SpToploButton >> iconForm: aForm [

	imageElement innerImage: aForm.
	imageElement visibility: BlVisibility visible
]

{ #category : #accessing }
SpToploButton >> iconFormOrNil: aFormOrNil [

	aFormOrNil
		ifNil: [ self setNoIcon ]
		ifNotNil: [ self iconForm: aFormOrNil ]
]

{ #category : #initialization }
SpToploButton >> initialize [

	| pane |
	super initialize.

	imageElement := ToImage new.
	labelElement := ToLabel new.
	
	pane := ToPane new.
	pane
		fitContent;
		addChild: imageElement as: #image;
		addChild: labelElement as: #label.
	pane layout alignCenter.

	self
		matchParent;
		addChild: pane.
	self layout alignCenter.
	
	self setNoIcon
]

{ #category : #accessing }
SpToploButton >> labelElement [

	^ labelElement
]

{ #category : #accessing }
SpToploButton >> labelString [

	^ labelElement text asString
]

{ #category : #accessing }
SpToploButton >> labelString: aString [

	labelElement text: aString asRopedText
]

{ #category : #accessing }
SpToploButton >> setNoIcon [

	self iconForm: NullIcon.
	imageElement visibility: BlVisibility hidden
]
