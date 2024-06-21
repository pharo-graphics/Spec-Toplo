Class {
	#name : #SpToploBoxAdapter,
	#superclass : #SpToploDirectionableLayoutAdapter,
	#instVars : [
		'startPane',
		'endPane'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploBoxAdapter >> addChildElement: aBlElement with: aSpBoxConstraints [
	"Add child to the Brick widget. This can be the start or end pane according to constraints's #isPlacedAtStart."

	(aSpBoxConstraints isPlacedAtStart
		ifTrue: [ startPane ]
		ifFalse: [ endPane ]) addChild: aBlElement
]

{ #category : #adding }
SpToploBoxAdapter >> addConstraints: aSpBoxConstraints toChild: childBlElement [
	"Inspired on SpMorphicBoxAdapter>>#addConstraints:toChild:"

	layout isHomogeneous 
		ifTrue: [ 1halt. "self addHomogeneousToMorph: childMorph" ].
	
	self updateChildPadding: childBlElement with: aSpBoxConstraints.

	aSpBoxConstraints isExpand 
		ifTrue: [
			self updateAsExpandedChild: childBlElement with: aSpBoxConstraints ]
		ifFalse: [
			self updateAsNonExpandedChild: childBlElement with: aSpBoxConstraints ].
	
	^ childBlElement
]

{ #category : #accessing }
SpToploBoxAdapter >> children [
	"Debug API. Answer the Toplo widgets that were added to this layout."

	^ Array streamContents: [ :stream |
		stream
			nextPutAll: startPane children;
			nextPutAll: endPane children ]
]

{ #category : #'instance creation' }
SpToploBoxAdapter >> newChildBlElement: aPresenter constrainedBy: aSpBoxConstraints [
	"Inspired on SpMorphicBoxAdapter>>#basicAdd:constraints:to:"

	| newElement |
	newElement := self newBlElementFrom: aPresenter constraints: aSpBoxConstraints.	

"	self applyAlignmentToChild: childMorph.
	self verifyBoxExtentOf: aPanel withChild: childMorph.
"
	^ newElement
]

{ #category : #'instance creation' }
SpToploBoxAdapter >> newHorizontal [
	"Configure as horizontal. See #newToploWidget."

	startPane := self newHorizontalPane.
	endPane := self newHorizontalPane
		hFitContent;
		yourself.

	^ self newHorizontalPane
		  addChild: startPane as: 'boxStart';
		  addChild: endPane as: 'boxEnd';
		  yourself
]

{ #category : #'instance creation' }
SpToploBoxAdapter >> newVertical [
	"Configure as vertical. See #newToploWidget."

	startPane := self newVerticalPane.
	endPane := self newVerticalPane
		vFitContent;
		yourself.

	^ self newVerticalPane
		  addChild: startPane as: 'boxStart';
		  addChild: endPane as: 'boxEnd';
		  yourself
]

{ #category : #adding }
SpToploBoxAdapter >> remove: aPresenter [

	| aBlElement adapter |
	adapter := aPresenter adapter.
	adapter ifNil: [ ^ self ].
	
	adapter unsubscribe.
	aBlElement := adapter widget.
	
	aBlElement parent = startPane ifTrue: [
		startPane removeChild: aBlElement ].
	aBlElement parent = endPane ifTrue: [
		endPane removeChild: aBlElement ].
	
"	self verifyBoxExtent"
]

{ #category : #accessing }
SpToploBoxAdapter >> replace: aPresenter with: otherPresenter withConstraints: constraints [

	| parentPane oldElement newElement |	
	oldElement := aPresenter adapter widget.
	parentPane := (startPane hasChild: oldElement)
		ifTrue: [ startPane ]
		ifFalse: [
			(endPane hasChild: oldElement)
				ifTrue: [ endPane ]
				ifFalse: [ self error: 'Presenter not found' ] ].

	otherPresenter owner: self presenter.

	newElement := self 
		newChildBlElement: otherPresenter
		constrainedBy: constraints.
	
	parentPane replaceChild: oldElement with: newElement
]

{ #category : #'as yet unclassified' }
SpToploBoxAdapter >> updateAsExpandedChild: childBlElement with: aSpBoxConstraints [
	
	"If is not 'fill', we need to pad it with another (since it 'expands', but does not 'fill')"
	aSpBoxConstraints isFill ifFalse: [ 
		1halt.
		"wrappedChild
			hResizing: #rigid;
			vResizing: #rigid.
		wrappedChild := self newPanel
			addMorphBack: wrappedChild;
			yourself" ]. 
	"Set to fill"
	childBlElement matchParent
]

{ #category : #'as yet unclassified' }
SpToploBoxAdapter >> updateChildPadding: aBlElement with: aSpBoxConstraints [

	| insets |
	insets := layout direction isHorizontal
		          ifTrue: [ BlInsets horizontal: aSpBoxConstraints padding ]
		          ifFalse: [ BlInsets vertical: aSpBoxConstraints padding ].

	aBlElement padding: insets
]
