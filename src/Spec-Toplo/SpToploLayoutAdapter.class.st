"
I'm a Spec adapter for layouts.
"
Class {
	#name : #SpToploLayoutAdapter,
	#superclass : #SpToploAdapter,
	#instVars : [
		'layout'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #initialization }
SpToploLayoutAdapter >> adaptToploWidget [
	"Override the adapt because the widget is still not created."
]

{ #category : #adding }
SpToploLayoutAdapter >> add: aPresenter constraints: constraints [ 
	"Add a new child to my presenter, and build it following the specified SpLayoutConstraints. 
	
	Inspired on SpMorphicLayoutAdapter>>#add:constraints:"

	| aBlElement |
	aPresenter owner: self presenter. 

	aBlElement := self 
		newChildBlElement: aPresenter
		constrainedBy: constraints.
	
	self addChildElement: aBlElement with: constraints
]

{ #category : #adding }
SpToploLayoutAdapter >> addConstraints: constraints toChild: childBlElement [
	"Inspired on SpMorphicLayoutAdapter>>#addConstraints:toChild:"

	^ self subclassResponsibility
]

{ #category : #factory }
SpToploLayoutAdapter >> buildWidget [
	"Postpone creation to #layout:"
	
	^ nil
]

{ #category : #building }
SpToploLayoutAdapter >> buildWithSelector: aSelector [
	"Inspired on SpMorphicLayoutAdapter>>#buildWithSelector:"

	^ self widget
]

{ #category : #accessing }
SpToploLayoutAdapter >> children [
	"Debug API. Answer the widgets added to this layout."

	^ self subclassResponsibility
]

{ #category : #testing }
SpToploLayoutAdapter >> isEmpty [
	
	^ self children isEmpty
]

{ #category : #protocol }
SpToploLayoutAdapter >> layout: aLayout [

	layout := aLayout.
	widget := self newToploWidget.

	"Note we send this message to super"
	super adaptToploWidget
]

{ #category : #'instance creation' }
SpToploLayoutAdapter >> newBlElementFrom: aPresenter constraints: constraints [
	"Inspired on SpMorphicLayoutAdapter>>#buildMorph:constraints:"

	| newElement |
	newElement := aPresenter buildWithSelector: constraints spec.

	"	self applyStyle: aPresenter to: childMorph.
	""Add children alignment constraints (if applies)""
	childMorph := self 
		applyChildrenAlignmentTo: childMorph 
		constraints: constraints. 
"
	newElement := self addConstraints: constraints toChild: newElement.

	^ newElement
]

{ #category : #'instance creation' }
SpToploLayoutAdapter >> newChildBlElement: aPresenter constrainedBy: constraints [
	"Answer a new Toplo widget that corresponds to the received Spec presenter. The answer should follow the specified layout constraints.
	
	Originally inspired on SpMorphicLayoutAdapter>>#basicAdd:constraints:to:"

	^ self subclassResponsibility
]

{ #category : #'instance creation' }
SpToploLayoutAdapter >> newToploWidget [
	"Answer the new Toplo widget."

	^ self subclassResponsibility
]

{ #category : #adding }
SpToploLayoutAdapter >> remove: aPresenter [

	self subclassResponsibility
]

{ #category : #initialization }
SpToploLayoutAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	layout whenChildrenAddedDo: [ :ann |
		self
			add: ann child
			constraints: (layout constraintsFor: ann child) ].
	
	layout whenChildrenRemovedDo: [ :ann |
		self remove: ann child ].

]
