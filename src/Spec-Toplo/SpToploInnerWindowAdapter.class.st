Class {
	#name : #SpToploInnerWindowAdapter,
	#superclass : #SpToploWindowAdapter,
	#instVars : [
		'containerWindow'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'widget creation' }
SpToploInnerWindowAdapter >> buildWidget [

	| w root |
	w := ToInnerWindow new.
	root := self newRootElement.
	root constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].

	w pane addChild: root as: #container.
	^ w
]

{ #category : #accessing }
SpToploInnerWindowAdapter >> container [
	
	^ self widget childWithId: #container
]

{ #category : #API }
SpToploInnerWindowAdapter >> open [

	containerWindow := (model application windows collect: [ :e | e adapter ]) detect: [ :e | e class = SpToploWindowAdapter ].

	containerWindow widget root content addChild: self widget
]

{ #category : #accessing }
SpToploInnerWindowAdapter >> updateContentWithSpecLayout: aSpExecutableLayout [
	"Build the presenter of the window, and establish the Toplo widget as content of the window."

	(widget pane childWithId: #container) content: (model presenter buildWithLayout: aSpExecutableLayout)
]

{ #category : #accessing }
SpToploInnerWindowAdapter >> updateDecorationsAsBorderless [
	
	
]

{ #category : #accessing }
SpToploInnerWindowAdapter >> updateMenu [

	model hasMenu ifFalse: [
		^ self container removeMenu ].

	"Build new Toplo menu from presenter spec and set it."	
	self container menu: model menu buildWithSpecAsPopup

]

{ #category : #'widget creation' }
SpToploInnerWindowAdapter >> updateStatusBar [

	model hasStatusBar ifFalse: [ ^ self container removeStatusBar ].

	"Build new Toplo status bar from presenter spec and set it."
	self container statusBar: model statusBar build
]

{ #category : #accessing }
SpToploInnerWindowAdapter >> updateToolbar [

	"Inspired on SpAbstractMorphicWindowAdapter>>#setToolbarTo:"

	model hasToolbar ifFalse: [ ^ self container removeToolbar ].

	"Build new Toplo toolbar from presenter spec and set it."
	self container toolbar: model toolbar build
]
