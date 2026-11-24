Class {
	#name : #SpToploGridAdapterTest,
	#superclass : #SpToploAbstractAdapterTest,
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #tests }
SpToploGridAdapterTest >> testBorderWidth [

	| presenter gridLayout window |
	presenter := application instantiate: SpPresenter.
	gridLayout :=
		SpGridLayout new
			borderWidth: 15;
			add: (presenter newLabel label: 'Test') atPoint: 1 @ 1;
			yourself.

	presenter layout: gridLayout.
	window := presenter asWindow.
	window open.
	window adapter widget settle.

	self assert: presenter adapter widget padding equals: (BlInsets all: 15)
]

{ #category : #tests }
SpToploGridAdapterTest >> testCellAlignment [

	| presenter label gridLayout widget window |
	presenter := application instantiate: SpPresenter.
	label := presenter newLabel label: 'Aligned'.

	gridLayout :=
		SpGridLayout new
			beColumnNotHomogeneous;
			add: label atPoint: 1 @ 1;
			yourself.
	(gridLayout constraintsFor: label)
		vAlignCenter;
		hAlignCenter.

	presenter layout: gridLayout.
	window := presenter asWindow.
	window open.
	window adapter widget settle.

	widget := label adapter widget.
	self assert: widget constraints grid vertical spec alignment class equals: BlGridCenterAlignment.
	self assert: widget constraints grid horizontal spec alignment class equals: BlGridCenterAlignment
]

{ #category : #tests }
SpToploGridAdapterTest >> testColumnAndRowSpacing [

	| presenter label1 label2 label3 label4 gridLayout widget1 widget2 widget3 widget4 window |
	presenter := application instantiate: SpPresenter.
	label1 := presenter newLabel label: '1'.
	label2 := presenter newLabel label: '2'.
	label3 := presenter newLabel label: '3'.
	label4 := presenter newLabel label: '4'.

	gridLayout :=
		SpGridLayout new
			columnSpacing: 12;
			rowSpacing: 7;
			add: label1 atPoint: 1 @ 1;
			add: label2 atPoint: 2 @ 1;
			add: label3 atPoint: 1 @ 2;
			add: label4 atPoint: 2 @ 2;
			yourself.

	presenter layout: gridLayout.
	window := presenter asWindow.
	window open.
	window adapter widget settle.

	widget1 := label1 adapter widget.
	widget2 := label2 adapter widget.
	widget3 := label3 adapter widget.
	widget4 := label4 adapter widget.

	self
		assert: widget1 margin
		equals: (BlInsets top: 0 right: 12 bottom: 7 left: 0).
	self
		assert: widget2 margin
		equals: (BlInsets top: 0 right: 0 bottom: 7 left: 0).
	self
		assert: widget3 margin
		equals: (BlInsets top: 0 right: 12 bottom: 0 left: 0).
	self assert: widget4 margin equals: BlInsets empty
]

{ #category : #tests }
SpToploGridAdapterTest >> testNonHomogeneousGridWithExpandableColumn [

	| presenter label input gridLayout window |
	presenter := application instantiate: SpPresenter.
	label := presenter newLabel label: 'Repository Name:'.
	input := presenter newTextInput.

	gridLayout :=
		SpGridLayout new
			beColumnNotHomogeneous;
			column: 2 expand: true;
			add: label atPoint: 1 @ 1;
			add: input atPoint: 2 @ 1;
			yourself.

	presenter layout: gridLayout.
	window := presenter asWindow.
	window
		initialExtent: 350 @ 200;
		open.
	window adapter widget settle.

	self assert: label adapter widget width < input adapter widget width.
	self assert: input adapter widget width > 100.
	self assert: input adapter widget height >= 20
]
