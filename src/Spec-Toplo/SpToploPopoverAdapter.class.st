"
I'm a Spec adapter for `SpPopoverPresenter`.
"
Class {
	#name : #SpToploPopoverAdapter,
	#superclass : #SpToploWidgetAdapter,
	#instVars : [
		'popupWindowHandler'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploPopoverAdapter >> buildWidget [

	| contentWidget |
	widget := ToElement new
		layout: BlLinearLayout vertical;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 8);
		background: Color white;
		border: (BlBorder paint: (Color gray alpha: 0.5) width: 1);
		padding: (BlInsets all: 8);
		fitContent;
		yourself.

	model presenter ifNotNil: [ :p |
		contentWidget := p build.
		contentWidget fitContent.
		widget addChild: contentWidget ].

	popupWindowHandler := ToPopupWindowManager new.
	popupWindowHandler closeOnReleased: false.
	popupWindowHandler windowBuilder: [ :popup :request |
		widget removeFromParent.
		popup fitContent.
		popup addChild: widget ].

	^ widget
]

{ #category : #api }
SpToploPopoverAdapter >> dismiss [

	popupWindowHandler currentWindowDo: [ :aWindow | aWindow close ]
]

{ #category : #private }
SpToploPopoverAdapter >> ensureAnchorElement [

	model relativeTo ifNotNil: [ :aPresenter |
		aPresenter withAdapterDo: [ :anAdapter |
			| anchor |
			anchor := anAdapter widget.
			(anchor hasEventHandler: popupWindowHandler)
				ifFalse: [ anchor addEventHandler: popupWindowHandler ] ] ]
]

{ #category : #'t - anchored window element - displaying' }
SpToploPopoverAdapter >> popup [

	self popupModal: false pointingTo: nil
]

{ #category : #api }
SpToploPopoverAdapter >> popupModal: aBoolean pointingTo: aRectangle [
	"Toplo currently uses the same popup infrastructure for modal and non-modal
	 popovers. The placement is still computed from the requested rectangle when
	 provided."

	self ensureAnchorElement.
	popupWindowHandler placement: (self popupPlacementPointingTo: aRectangle).
	popupWindowHandler popup.
	model isTransferFocus ifTrue: [ model takeKeyboardFocus ].
	model popoverOpened
]

{ #category : #'private - positioning' }
SpToploPopoverAdapter >> popupPlacementPointingTo: aRectangle [

	^ ToActionPlacement new
		  action: [ :aWindow :anEvent :aBoundsUpdater | aWindow position: (self popupPositionFor: aWindow pointingTo: aRectangle) ];
		  yourself
]

{ #category : #'private - positioning' }
SpToploPopoverAdapter >> popupPositionFor: aWindow pointingTo: aRectangle [

	| targetBounds centeredX |
	targetBounds := self popupTargetBoundsFor: aRectangle window: aWindow.
	centeredX := targetBounds topCenter x - (aWindow measuredWidth / 2.0).
	model position == SpPopoverPosition top ifTrue: [ ^ centeredX @ (targetBounds top - aWindow measuredHeight) ].
	model position == SpPopoverPosition left ifTrue: [ ^ targetBounds left - aWindow measuredWidth @ targetBounds top ].
	model position == SpPopoverPosition right ifTrue: [ ^ targetBounds right @ targetBounds top ].
	^ centeredX @ targetBounds bottom
]

{ #category : #'private - positioning' }
SpToploPopoverAdapter >> popupTargetBoundsFor: aRectangle window: aWindow [

	| root |
	root := aWindow anchorRoot.
	aRectangle ifNil: [ ^ (aWindow anchorElement bounds inParent: root) bounds ].
	^ (root globalPointToLocal: aRectangle topLeft) corner: (root globalPointToLocal: aRectangle bottomRight)
]

{ #category : #accessing }
SpToploPopoverAdapter >> popupWindowHandler [

	^ popupWindowHandler
]

{ #category : #accessing }
SpToploPopoverAdapter >> popupWindowHandler: anObject [

	popupWindowHandler := anObject
]
