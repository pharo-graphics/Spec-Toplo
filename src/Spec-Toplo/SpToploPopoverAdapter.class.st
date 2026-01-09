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

	popupWindowHandler popup
]

{ #category : #accessing }
SpToploPopoverAdapter >> popupWindowHandler [

	^ popupWindowHandler
]

{ #category : #accessing }
SpToploPopoverAdapter >> popupWindowHandler: anObject [

	popupWindowHandler := anObject
]
