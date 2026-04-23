"
I'm a Spec adapter for `SpToolbarButtonPresenter`.
"
Class {
	#name : #SpToploToolbarButtonAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploToolbarButtonAdapter >> buildWidget [

	| menu |
	menu := ToMenuItem new.
	menu vertical: true.
	menu alignCenter: true.
	^ menu
]

{ #category : #'private - icon' }
SpToploToolbarButtonAdapter >> iconSourceForWidgetFrom: anIcon [

	(anIcon isKindOf: ToImage) ifFalse: [ ^ anIcon ].
	^ anIcon sourceImage
]

{ #category : #initialization }
SpToploToolbarButtonAdapter >> subscribeToPresenter [

	model
		whenLabelChangedDo: [ self updateLabel ];
		whenIconChangedDo: [ self updateIcon ]
]

{ #category : #initialization }
SpToploToolbarButtonAdapter >> updateAction [

	model action ifNotNil: [ widget clickAction: model action ]
]

{ #category : #initialization }
SpToploToolbarButtonAdapter >> updateAll [

	super updateAll.
	self
		updateLabel;
		updateIcon;
		updateAction
]

{ #category : #updating }
SpToploToolbarButtonAdapter >> updateIcon [

	model icon ifNotNil: [ widget iconImage: (self iconSourceForWidgetFrom: model icon) ]
]

{ #category : #updating }
SpToploToolbarButtonAdapter >> updateLabel [

	model label ifNotNil: [ widget labelText: model label ]
]
