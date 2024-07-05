Class {
	#name : #SpToploButtonBarAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploButtonBarAdapter >> buildWidget [

	^ ToPane horizontal
		layout: (BlLinearLayout horizontal
			cellSpacing: 5;
			yourself);
"		  cellSpacing: 5;"
		  padding: (BlInsets top: 0 left: 5 bottom: 5 right: 10);
		  margin: (BlInsets horizontal: 5);
"		  alignCenterRight;"
"		  addChildren: self newToploButtons;"
		  yourself
]

{ #category : #factory }
SpToploButtonBarAdapter >> newToploButtons [

	^ model items collect: [ :each | 
		  each build
			  hExact: 100;
			  yourself ]
]

{ #category : #'as yet unclassified' }
SpToploButtonBarAdapter >> updateAlignment [

	model isPlaceAtStart
		ifTrue: [ widget layoutDo: [ :l | l alignCenterLeft ] ]
		ifFalse: [ widget layoutDo: [ :l | l alignCenterRight ] ]
]

{ #category : #initialization }
SpToploButtonBarAdapter >> updateAll [

	super updateAll.
	
	self 
		updateItems;
		updateAlignment
]

{ #category : #'updating widget' }
SpToploButtonBarAdapter >> updateEnabled [

	self flag: #todo. "Ignore?"
]

{ #category : #'updating widget' }
SpToploButtonBarAdapter >> updateItems [

	widget
		removeChildren;
		addChildren: self newToploButtons
]
