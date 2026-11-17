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

	self updateGridDimensions.
	widget addChild: aChildElement
]

{ #category : #adding }
SpToploGridAdapter >> addConstraints: constraints toChild: childBlElement [

	| col spanX row spanY isColExpand isRowExpand |
	constraints ifNil: [ ^ childBlElement ].

	col := constraints column.
	spanX := constraints columnSpan.
	row := constraints row.
	spanY := constraints rowSpan.

	isColExpand := layout isColumnHomogeneous or: [
		(col to: col + spanX - 1) anySatisfy: [ :eachCol |
			(layout columnConstraintsAt: eachCol)
				ifNotNil: [ :c | c isExpand ]
				ifNil: [ false ] ] ].

	isRowExpand := layout isRowHomogeneous or: [
		(row to: row + spanY - 1) anySatisfy: [ :eachRow |
			(layout rowConstraintsAt: eachRow)
				ifNotNil: [ :c | c isExpand ]
				ifNil: [ false ] ] ].

	childBlElement constraintsDo: [ :c |
		isColExpand
			ifTrue: [ c horizontal matchParent ]
			ifFalse: [
				childBlElement constraints horizontal resizer isExact ifFalse: [
					c horizontal fitContent ] ].
		isRowExpand
			ifTrue: [ c vertical matchParent ]
			ifFalse: [
				childBlElement constraints vertical resizer isExact ifFalse: [
					c vertical fitContent ] ].
		c grid horizontal span: spanX.
		c grid vertical span: spanY ].

	^ childBlElement
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

{ #category : #updating }
SpToploGridAdapter >> updateGridDimensions [

	widget layout columnCount: self calculateColumnCount.
	widget layout rowCount: self calculateRowCount
]
