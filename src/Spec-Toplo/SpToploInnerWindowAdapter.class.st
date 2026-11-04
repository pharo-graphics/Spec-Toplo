"
I'm an alternative Spec adapter for `SpWindowPresenter` that uses a `ToInnerWindow`. Check class references.
"
Class {
	#name : #SpToploInnerWindowAdapter,
	#superclass : #SpToploWindowAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploInnerWindowAdapter >> buildWidget [

	| innerWindow containerElement |
	innerWindow := ToInnerWindow new.
	containerElement := self newRootElement.
	containerElement constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	innerWindow pane addChild: containerElement as: #container.
	^ innerWindow
]

{ #category : #accessing }
SpToploInnerWindowAdapter >> container [
	
	^ widget childWithId: #container
]

{ #category : #API }
SpToploInnerWindowAdapter >> open [

	model application backend openInnerWindow: widget on: model application
]

{ #category : #accessing }
SpToploInnerWindowAdapter >> updateContentWithSpecLayout: aSpExecutableLayout [
	"Build the presenter of the window, and establish the Toplo widget as content of the window."

	(widget pane childWithId: #container) content:
		(model presenter buildWithLayout: aSpExecutableLayout)
]

{ #category : #accessing }
SpToploInnerWindowAdapter >> updateDecorationsAsBorderless [
	
	
]

{ #category : #'widget creation' }
SpToploInnerWindowAdapter >> updateMenu [

	model hasMenu ifFalse: [ ^ self container removeMenu ].

	"Build new Toplo menu from presenter spec and set it."	
	self container menu: model menu buildWithSpecAsPopup

]

{ #category : #'widget creation' }
SpToploInnerWindowAdapter >> updateStatusBar [

	model hasStatusbar ifFalse: [ ^ self container removeStatusBar ].

	"Build new Toplo status bar from presenter spec and set it."
	self container statusBar: model statusbar build
]

{ #category : #'widget creation' }
SpToploInnerWindowAdapter >> updateToolbar [

	model hasToolbar ifFalse: [ ^ self container removeToolbar ].

	"Build new Toplo toolbar from presenter spec and set it."
	self container toolbar: model toolbar build
]

{ #category : #accessing }
SpToploInnerWindowAdapter >> widgetSpace [

	^ widget space
]
