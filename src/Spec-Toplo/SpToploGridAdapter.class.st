"
I'm a Spec adapter for `SpGridLayout`.
"
Class {
	#name : #SpToploGridAdapter,
	#superclass : #SpToploLayoutAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploGridAdapter >> addChildElement: aChildElement with: aSpGridConstraints [

	widget addChild: aChildElement.
	self updateGridDimensions
]

{ #category : #adding }
SpToploGridAdapter >> addConstraints: constraints toChild: childBlElement [

	| col spanX row spanY isColExpand isRowExpand |
	constraints ifNil: [ ^ childBlElement ].

	col := constraints column.
	spanX := constraints columnSpan.
	row := constraints row.
	spanY := constraints rowSpan.

	isColExpand :=
		layout isColumnHomogeneous or: [
			(col to: col + spanX - 1) anySatisfy: [ :eachCol |
				(layout columnConstraintsAt: eachCol) ifNotNil: [ :c | c isExpand ] ifNil: [ false ] ] ].

	isRowExpand :=
		layout isRowHomogeneous or: [
			(row to: row + spanY - 1) anySatisfy: [ :eachRow |
				(layout rowConstraintsAt: eachRow) ifNotNil: [ :c | c isExpand ] ifNil: [ false ] ] ].

	childBlElement constraintsDo: [ :c |
		isColExpand
			ifTrue: [ c horizontal matchParent ]
			ifFalse: [ childBlElement constraints horizontal resizer isExact ifFalse: [ c horizontal fitContent ] ].
		isRowExpand
			ifTrue: [ c vertical matchParent ]
			ifFalse: [ childBlElement constraints vertical resizer isExact ifFalse: [ c vertical fitContent ] ].
		c grid horizontal span: spanX.
		c grid vertical span: spanY ].

	self
		applySpacingToChild: childBlElement constraints: constraints;
		applyAlignmentToChild: childBlElement constraints: constraints.

	^ childBlElement
]

{ #category : #private }
SpToploGridAdapter >> applyAlignmentToChild: childBlElement constraints: constraints [

	| effectiveVAlign effectiveHAlign |
	effectiveVAlign :=
		constraints hasVAlign
			ifTrue: [ constraints vAlign ]
			ifFalse: [
				(layout rowConstraintsAt: constraints row)
					ifNotNil: [ :rc | rc hasVAlign ifTrue: [ rc vAlign ] ]
					ifNil: [
						(layout columnConstraintsAt: constraints column)
							ifNotNil: [ :cc | cc hasVAlign ifTrue: [ cc vAlign ] ] ] ].

	effectiveHAlign :=
		constraints hasHAlign
			ifTrue: [ constraints hAlign ]
			ifFalse: [
				(layout columnConstraintsAt: constraints column)
					ifNotNil: [ :cc | cc hasHAlign ifTrue: [ cc hAlign ] ]
					ifNil: [
						(layout rowConstraintsAt: constraints row)
							ifNotNil: [ :rc | rc hasHAlign ifTrue: [ rc hAlign ] ] ] ].

	childBlElement constraintsDo: [ :c |
		effectiveVAlign ifNotNil: [ :align |
			align = SpLayoutWidgetAlignment start ifTrue: [ c grid vertical alignTop ].
			align = SpLayoutWidgetAlignment center ifTrue: [ c grid vertical alignCenter ].
			align = SpLayoutWidgetAlignment end ifTrue: [ c grid vertical alignBottom ] ].
		effectiveHAlign ifNotNil: [ :align |
			align = SpLayoutWidgetAlignment start ifTrue: [ c grid horizontal alignLeft ].
			align = SpLayoutWidgetAlignment center ifTrue: [ c grid horizontal alignCenter ].
			align = SpLayoutWidgetAlignment end ifTrue: [ c grid horizontal alignRight ] ] ]
]

{ #category : #private }
SpToploGridAdapter >> applySpacingToChild: childBlElement constraints: constraints [

	| rightMargin bottomMargin |
	rightMargin :=
		constraints column + constraints columnSpan - 1 < self calculateColumnCount
			ifTrue: [ layout columnSpacing ]
			ifFalse: [ 0 ].
	bottomMargin :=
		constraints row + constraints rowSpan - 1 < self calculateRowCount
			ifTrue: [ layout rowSpacing ]
			ifFalse: [ 0 ].
	childBlElement margin:
		(BlInsets
			 top: 0
			 left: 0
			 bottom: bottomMargin
			 right: rightMargin)
]

{ #category : #accessing }
SpToploGridAdapter >> calculateColumnCount [
	"Answer the maximum column index reached by any child (offset by -1 for 1-based inclusive span)."

	^ (layout children values collect: [ :each | each column + each columnSpan - 1 ])
		ifNotEmpty: #max
		ifEmpty: [ 0 ]
]

{ #category : #accessing }
SpToploGridAdapter >> calculateRowCount [
	"Answer the maximum row index reached by any child (offset by -1 for 1-based inclusive span)."

	^ (layout children values collect: [ :each | each row + each rowSpan - 1 ])
		ifNotEmpty: #max
		ifEmpty: [ 0 ]
]

{ #category : #protocol }
SpToploGridAdapter >> layout: aLayout [

	super layout: aLayout.
	self updateBorderWidth
]

{ #category : #'instance creation' }
SpToploGridAdapter >> newChildBlElement: aPresenter constrainedBy: constraints [

	^ self newBlElementFrom: aPresenter constraints: constraints
]

{ #category : #factory }
SpToploGridAdapter >> newToploWidget [

	| gridLayout |
	gridLayout := BlGridLayout horizontal.
	^ ToPane new
		layout: gridLayout;
		yourself
]

{ #category : #adding }
SpToploGridAdapter >> remove: aPresenter [

	super remove: aPresenter.
	self updateGridDimensions
]

{ #category : #initialization }
SpToploGridAdapter >> updateAll [

	super updateAll.
	self updateBorderWidth
]

{ #category : #updating }
SpToploGridAdapter >> updateBorderWidth [

	widget ifNotNil: [ widget padding: (BlInsets all: layout borderWidth) ]
]

{ #category : #updating }
SpToploGridAdapter >> updateGridDimensions [

	widget layout columnCount: self calculateColumnCount.
	widget layout rowCount: self calculateRowCount
]
