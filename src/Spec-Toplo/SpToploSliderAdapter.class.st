Class {
	#name : #SpToploSliderAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploSliderAdapter >> buildWidget [
	
	^ ToBasicHorizontalSlider new
		  minValue: self model min;
		  maxValue: self model max;
		  yourself
]

{ #category : #initialization }
SpToploSliderAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	self presenter whenValueChangedDo: [ :newValue | self widget setValue: newValue ].
	self presenter whenMinChangedDo: [ :newValue | self widget minValue: newValue ].
	self presenter whenMaxChangedDo: [ :newValue | self widget maxValue: newValue ].
	self presenter whenQuantumChangedDo: [ :newValue | self widget quantum: newValue ].
	self presenter whenLabelChangedDo: [ :newLabel | self widget label: newLabel ].
	self presenter whenAbsoluteValueChangedDo: [ :newValue | self widget setValue: newValue ]
]

{ #category : #debug }
SpToploSliderAdapter >> widgetAbsoluteValue [

	| current total |
	current := self widget currentValue - self widget minValue.
	total := self widget maxValue - self widget minValue.
	^ (current / total) asFloat
]

{ #category : #debug }
SpToploSliderAdapter >> widgetValue [
	^ self widget currentValue
]
