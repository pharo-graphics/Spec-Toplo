Class {
	#name : #SpToploScrollableAdapter,
	#superclass : #SpToploLayoutAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploScrollableAdapter >> addChildElement: aToElement with: aSpBoxConstraints [
	 
	self widget children first addChild: aToElement
]

{ #category : #adding }
SpToploScrollableAdapter >> addConstraints: aSpBoxConstraints toChild: childBlElement [

	self flag:
		#'Fit Content is required so that child keep their minimal width and height instead of shreaking infinitly. Maybe we need to play with minWidth: and minHeight: instead of current implementation'.
	childBlElement fitContent.

	^ childBlElement
]

{ #category : #'instance creation' }
SpToploScrollableAdapter >> newChildBlElement: aPresenter constrainedBy: aSpBoxConstraints [

	^ self newBlElementFrom: aPresenter constraints: aSpBoxConstraints
]

{ #category : #'instance creation' }
SpToploScrollableAdapter >> newToploWidget [

	| scrollableElement hBar vBar scrollPane |
	scrollableElement := ToScrollableElement new
		                     constraintsDo: [ :c |
				                     c horizontal matchParent.
				                     c vertical matchParent ];
		                     yourself.

	hBar := BlHorizontalScrollbarElement new
		        constraintsDo: [ :c |
				        c ignoreByLayout.
				        c ignored vertical alignBottom ];
		        attachTo: scrollableElement;
		        yourself.

	vBar := BlVerticalScrollbarElement new
		        constraintsDo: [ :c |
				        c ignoreByLayout.
				        c ignored horizontal alignRight ];
		        attachTo: scrollableElement;
		        yourself.

	scrollPane := ToPane new
		              addChild: scrollableElement;
		              addChild: vBar;
		              addChild: hBar;
		              margin: (BlInsets all: 8);
		              constraintsDo: [ :c |
				              c horizontal matchParent.
				              c vertical matchParent ];
		              yourself.

	^ scrollPane
]
