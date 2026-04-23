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

	widget := ToPane new.
	popupWindowHandler := ToPopupWindowManager new.
	popupWindowHandler windowBuilder: [ :popup :request |
			| child |
			child := self model presenter build.
			child matchParent.

			popup border: Color gray.
			
			popup height: model preferredExtent y / 10. "I don't know why divided by ten but it looks visually correct"
			popup width: model preferredExtent x.
			popup addChild: child ].
	self presenter relativeTo adapter widget addEventHandler:
		popupWindowHandler.
	^ widget
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

	popupWindowHandler placement: (self popupPlacementPointingTo: aRectangle).
	popupWindowHandler popup.
	self presenter isTransferFocus ifTrue: [ self presenter takeKeyboardFocus ].
	self presenter popoverOpened
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
	self presenter position == SpPopoverPosition top ifTrue: [ ^ centeredX @ (targetBounds top - aWindow measuredHeight) ].
	self presenter position == SpPopoverPosition left ifTrue: [ ^ targetBounds left - aWindow measuredWidth @ targetBounds top ].
	self presenter position == SpPopoverPosition right ifTrue: [ ^ targetBounds right @ targetBounds top ].
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
