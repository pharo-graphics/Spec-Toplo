Class {
	#name : #SpToploTableColumnSkin,
	#superclass : #ToLabelSkin,
	#instVars : [
		'italic',
		'foreground',
		'bold'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #accessing }
SpToploTableColumnSkin >> bold [

	^ bold
]

{ #category : #accessing }
SpToploTableColumnSkin >> bold: anObject [

	bold := anObject
]

{ #category : #'event handling' }
SpToploTableColumnSkin >> deselectedSkinEvent: anEvent [

	super deselectedSkinEvent: anEvent.
	anEvent selectionMode isPrimary ifFalse: [ ^ self ].
	anEvent selectionMode selectionOption isMasked ifTrue: [ ^ self ].
	anEvent elementDo: [ :e | "e text asString = 'Alaska' ifTrue: [ anEvent traceCr ]."
			self foreground
				ifNotNil: [ :f | e foreground: f ]
				ifNil: [ e foreground: (e valueOfTokenNamed: #'color-text') ] ]
]

{ #category : #'event handling' }
SpToploTableColumnSkin >> enabledSkinEvent: anEvent [

	super enabledSkinEvent: anEvent.
	anEvent elementDo: [ :e |
			"e text asString = '2: BB' ifTrue: [ anEvent traceCr ]."
			self foreground
				ifNotNil: [ :f | e foreground: f ]
				ifNil: [ e foreground: (e valueOfTokenNamed: #'color-text') ] ]
]

{ #category : #accessing }
SpToploTableColumnSkin >> foreground [

	^ foreground
]

{ #category : #accessing }
SpToploTableColumnSkin >> foreground: anObject [

	foreground := anObject
]

{ #category : #accessing }
SpToploTableColumnSkin >> initialize [

	super initialize.
	bold := false.
	italic := false
]

{ #category : #'event handling' }
SpToploTableColumnSkin >> installSkinEvent: anEvent [

	super installSkinEvent: anEvent.

	anEvent elementDo: [ :e |
			e textAttributesBuilder
				defaultFontSize: (e valueOfTokenNamed: #'font-size');
				lineSpacing: (e valueOfTokenNamed: #'line-height');
				attribute: (e valueOfTokenNamed: #'font-weight-attribute').
			self italic ifTrue: [ e textAttributesBuilder attribute: BlFontEmphasisAttribute italic ].
			self bold ifTrue: [ e textAttributesBuilder attribute: BlFontWeightAttribute bold ].
			self foreground
				ifNotNil: [ :f | e foreground: f ]
				ifNil: [ e foreground: (e valueOfTokenNamed: #'color-text') ].
			e applyStyle ]
]

{ #category : #accessing }
SpToploTableColumnSkin >> italic [

	^ italic
]

{ #category : #accessing }
SpToploTableColumnSkin >> italic: anObject [

	italic := anObject
]
