Class {
	#name : #SpToploAbstractTextAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #accessing }
SpToploAbstractTextAdapter >> placeHolderText [

	^ widget userData at: #specPlaceholder ifAbsent: [ nil ]
]

{ #category : #initialization }
SpToploAbstractTextAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model
		whenTextChangedDo: [ self updateText ];
		whenPlaceholderChangedDo: [ self updatePlaceholder ]
]

{ #category : #'updating widget' }
SpToploAbstractTextAdapter >> updateAll [

	super updateAll.
	
	self
		updateText;
		updatePlaceholder
]

{ #category : #'updating widget' }
SpToploAbstractTextAdapter >> updatePlaceholder [

	widget userData at: #specPlaceholder put: model placeholder.
	widget placeholderText: model placeholder
]

{ #category : #'updating widget' }
SpToploAbstractTextAdapter >> updateText [

	widget text: model text
]
