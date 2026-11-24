Class {
	#name : #SpToploToolbarAdapterTest,
	#superclass : #SpToploAbstractAdapterTest,
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #tests }
SpToploToolbarAdapterTest >> testBuildWithToImageIconKeepsSourceIconDetached [

	| presenter button sourceIcon widget builtItem |
	presenter := SpToolbarPresenter new
		             application: application;
		             yourself.
	button := SpToolbarButtonPresenter new
		          application: application;
		          yourself.
	sourceIcon := ToMaterialDesignIconProvider new iconNamed: #outlined_menu ifAbsent: [ self fail ].
	button icon: sourceIcon.
	presenter add: button.

	widget := presenter build.
	builtItem := widget items first.

	self assert: builtItem class equals: ToMenuItem.
	self assert: sourceIcon parent isNil.
	self deny: builtItem startElement identicalTo: sourceIcon.
	self assert: builtItem startElement sourceImage equals: sourceIcon sourceImage
]

{ #category : #tests }
SpToploToolbarAdapterTest >> testLeftAndRightItemsSeparatedByFiller [

	| presenter leftButton rightButton window toolbarAdapter widget leftNode fillerNode rightNode |
	presenter := SpPresenter newApplication: application.
	leftButton := SpToolbarButtonPresenter new
		              application: application;
		              label: 'Left';
		              yourself.
	rightButton := SpToolbarButtonPresenter new
		               application: application;
		               label: 'Right';
		               yourself.

	presenter layout: (SpBoxLayout newTopToBottom
		 add: (SpToolbarPresenter new
			  application: application;
			  addItemLeft: leftButton;
			  addItemRight: rightButton;
			  yourself);
		 yourself).

	window := presenter asWindow.
	window open.
	window window space settle.

	toolbarAdapter := presenter layout presenters first adapter.
	widget := toolbarAdapter widget.
	leftNode := widget itemList nodes first.
	fillerNode := widget itemList nodes second.
	rightNode := widget itemList nodes third.

	self assert: toolbarAdapter numberOfItems equals: 2.
	self assert: widget items second class equals: ToMenuFiller.
	self assert: leftNode bounds inSpace bounds right <= fillerNode bounds inSpace bounds left.
	self assert: fillerNode bounds inSpace bounds right <= rightNode bounds inSpace bounds left.
	self assert: rightNode bounds inSpace bounds right > (widget width / 2)
]

{ #category : #tests }
SpToploToolbarAdapterTest >> testOnlyRightItemsSeparatedByFiller [

	| presenter rightButton window toolbarAdapter widget fillerNode rightNode |
	presenter := SpPresenter newApplication: application.
	rightButton := SpToolbarButtonPresenter new
		               application: application;
		               label: 'RightOnly';
		               yourself.

	presenter layout: (SpBoxLayout newTopToBottom
		 add: (SpToolbarPresenter new
			  application: application;
			  addItemRight: rightButton;
			  yourself);
		 yourself).

	window := presenter asWindow.
	window open.
	window window space settle.

	toolbarAdapter := presenter layout presenters first adapter.
	widget := toolbarAdapter widget.
	fillerNode := widget itemList nodes first.
	rightNode := widget itemList nodes second.

	self assert: toolbarAdapter numberOfItems equals: 1.
	self assert: widget items first class equals: ToMenuFiller.
	self assert: fillerNode bounds inSpace bounds right <= rightNode bounds inSpace bounds left.
	self assert: rightNode bounds inSpace bounds right > (widget width / 2)
]
