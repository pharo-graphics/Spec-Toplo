Class {
	#name : #SpToploPopoverAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application',
		'anchorPresenter',
		'popover'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #'test - building' }
SpToploPopoverAdapterTest >> buildAnchorPresenter [

	anchorPresenter := SpButtonPresenter new
		                   application: application;
		                   label: 'Anchor';
		                   yourself.
	anchorPresenter open.
	self waitUntilUIRedrawed.
	^ anchorPresenter
]

{ #category : #'test - building' }
SpToploPopoverAdapterTest >> buildPopoverRelativeTo: aPresenter [

	| content |
	content := SpLabelPresenter new
		           application: application;
		           label: 'Popover';
		           yourself.
	popover := aPresenter newPopover.
	popover relativeTo: aPresenter.
	popover presenter: content.
	popover doNotTransferFocus.
	popover build.
	^ popover
]

{ #category : #'test - building' }
SpToploPopoverAdapterTest >> newFakeWindowMeasuredWidth: aWidth height: aHeight [

	| anchorElement anchorRoot |
	anchorElement := anchorPresenter adapter widget.
	anchorRoot := anchorElement parent ifNil: [ anchorElement ].
	^ SpToploPopoverAdapterTestWindow new
		  anchorElement: anchorElement
		  anchorRoot: anchorRoot
		  measuredWidth: aWidth
		  measuredHeight: aHeight;
		  yourself
]

{ #category : #running }
SpToploPopoverAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #running }
SpToploPopoverAdapterTest >> tearDown [

	popover ifNotNil: [
			popover withAdapterDo: [ :adapter |
				adapter popupWindowHandler currentWindowDo: [ :aWindow | aWindow isOpened ifTrue: [ aWindow close ] ] ] ].
	application ifNotNil: [ application windows do: [ :each | each delete ] ].
	super tearDown
]

{ #category : #tests }
SpToploPopoverAdapterTest >> testPopupModalPointingToUsesRectangleForRightPosition [

	| fakeWindow rectangle expectedPosition |
	self buildAnchorPresenter.
	self buildPopoverRelativeTo: anchorPresenter.
	popover bePositionRight.
	fakeWindow := self newFakeWindowMeasuredWidth: 120 height: 50.
	rectangle := 25 @ 35 extent: 40 @ 12.
	expectedPosition := fakeWindow anchorRoot globalPointToLocal: rectangle right @ rectangle top.
	self assert: (popover adapter popupPositionFor: fakeWindow pointingTo: rectangle) equals: expectedPosition
]

{ #category : #tests }
SpToploPopoverAdapterTest >> testPopupModalWithoutRectangleUsesAnchorBoundsForBottomPosition [

	| fakeWindow anchorBounds centeredX |
	self buildAnchorPresenter.
	self buildPopoverRelativeTo: anchorPresenter.
	popover bePositionBottom.
	fakeWindow := self newFakeWindowMeasuredWidth: 150 height: 60.
	anchorBounds := (fakeWindow anchorElement bounds inParent: fakeWindow anchorRoot) bounds.
	centeredX := anchorBounds topCenter x - (fakeWindow measuredWidth / 2.0).
	self assert: (popover adapter popupPositionFor: fakeWindow pointingTo: nil) equals: centeredX @ anchorBounds bottom
]

{ #category : #running }
SpToploPopoverAdapterTest >> waitUntilUIRedrawed [

	| aSpace |
	aSpace := application windows anyOne adapter widget.
	BlSpace pulseUntilSpaceOpenedAndEmptyTaskQueue: aSpace timeout: 200 milliSeconds
]
