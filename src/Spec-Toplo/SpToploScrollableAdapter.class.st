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
	"Add constraint from Spec2 and apply custom constraint required by Toplo"

	"Compute size in fit context"

	childBlElement whenLayoutedDoOnce: [
			childBlElement fitContent.

			"Set min values. These values will be used when computing when to display scrollbar"
			childBlElement minWidth: childBlElement width.
			childBlElement minHeight: childBlElement height.
			"reset to default matchParent"
			childBlElement matchParent ].




	aSpBoxConstraints isExpand ifFalse: [
		self
			updateAsNonExpandedChild: childBlElement
			with: aSpBoxConstraints ].

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

	scrollPane := ToElement new
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

{ #category : #adding }
SpToploScrollableAdapter >> updateAsNonExpandedChild: childBlElement with: aSpBoxConstraints [
	"Set up child to stay rigid in the layout direction."

	layout direction setRigidityOfNonExpandedBlElement: childBlElement.
	aSpBoxConstraints width ifNotNil: [ :w | 
		childBlElement width: w ].
	aSpBoxConstraints height ifNotNil: [ :h | 
		childBlElement height: h ]
]
