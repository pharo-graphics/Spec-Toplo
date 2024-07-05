"
I'm the root element of a `BlSpace` that represents a `SpWindowPresenter`.


"
Class {
	#name : #SpToploWindowElement,
	#superclass : #BlElement,
	#instVars : [
		'menu',
		'toolbar',
		'content',
		'statusBar'
	],
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #accessing }
SpToploWindowElement >> content [

	^ content
]

{ #category : #accessing }
SpToploWindowElement >> content: aBlElement [

	aBlElement constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
		
	self replaceChild: content with: aBlElement.
	content := aBlElement
]

{ #category : #initialization }
SpToploWindowElement >> initialize [

	super initialize.

	self
		layout: BlLinearLayout vertical;
		background: Color white.
	
	menu := self newEmptyElement.
	content := self newEmptyElement.
	statusBar := self newEmptyElement.
	toolbar := self newEmptyElement.
	
	self
		addChild: menu as: #menu;
		addChild: toolbar as: #toolbar;
		addChild: content as: #content;
		addChild: statusBar as: #statusBar.

]

{ #category : #accessing }
SpToploWindowElement >> menu [

	^ menu
]

{ #category : #accessing }
SpToploWindowElement >> menu: aBlElement [

	aBlElement constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	self replaceChild: menu with: aBlElement.
	menu := aBlElement
]

{ #category : #initialization }
SpToploWindowElement >> newEmptyElement [

	^ BlElement new
		  size: 10 @ 10;
		  yourself
]

{ #category : #accessing }
SpToploWindowElement >> removeMenu [

	self menu: self newEmptyElement
]

{ #category : #accessing }
SpToploWindowElement >> removeStatusBar [
	
	self statusBar: self newEmptyElement	
]

{ #category : #accessing }
SpToploWindowElement >> removeToolbar [

	self toolbar: self newEmptyElement	
]

{ #category : #accessing }
SpToploWindowElement >> statusBar [

	^ statusBar
]

{ #category : #accessing }
SpToploWindowElement >> statusBar: aBlElement [

	aBlElement constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	self replaceChild: statusBar with: aBlElement.
	statusBar := aBlElement
]

{ #category : #accessing }
SpToploWindowElement >> toolbar [

	^ toolbar
]

{ #category : #accessing }
SpToploWindowElement >> toolbar: aBlElement [

	aBlElement constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].


	self replaceChild: toolbar with: aBlElement.
	toolbar := aBlElement
]
