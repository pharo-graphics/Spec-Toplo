"
I'm a Spec adapter for `SpImagePresenter`.
"
Class {
	#name : #SpToploImageAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploImageAdapter >> buildWidget [

	^ ToImage new
]

{ #category : #testing }
SpToploImageAdapter >> hasImageAutoscaled [

	^ false
]

{ #category : #accessing }
SpToploImageAdapter >> image [
	
	^ widget innerForm
]

{ #category : #initialization }
SpToploImageAdapter >> subscribeToPresenter [

	model
		whenImageChangeDo: [ self updateImage ];
		whenAutoScaleChangeDo: [ self updateAutoScale ]
]

{ #category : #initialization }
SpToploImageAdapter >> updateAll [

	super updateAll.

	self
		updateImage;
		updateAutoScale
]

{ #category : #'updating widget' }
SpToploImageAdapter >> updateAutoScale [

	self flag: #todo
]

{ #category : #'updating widget' }
SpToploImageAdapter >> updateImage [

	widget innerImage: model image
]
