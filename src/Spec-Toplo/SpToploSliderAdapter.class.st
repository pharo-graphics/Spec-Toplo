Class {
	#name : #SpToploSliderAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploSliderAdapter >> buildWidget [

	| slider |
	slider := ToBasicHorizontalSlider new
		          minValue: self model min;
		          maxValue: self model max;
		          quantum: self model quantum;
		          newValueCallback: [ :newValue | self presenter value: newValue ];
		          yourself.
	slider setValue: self scaledPresenterValue.
	slider labelText: self model label.
	^ slider
]

{ #category : #updating }
SpToploSliderAdapter >> round: aNumber toQuantum: aQuantum [
	"Answer aNumber rounded to aQuantum. A nil or zero quantum means no rounding"

	(aQuantum isNil or: [ aQuantum isZero ]) ifTrue: [ ^ aNumber ].
	^ aNumber roundTo: aQuantum
]

{ #category : #updating }
SpToploSliderAdapter >> scaledPresenterValue [
	"Answer the presenter position (absolute value, 0 to 1) in the min..max range, rounded to the quantum"

	| scaledValue |
	scaledValue := self presenter min + (self presenter absoluteValue * (self presenter max - self presenter min)).
	^ self round: scaledValue toQuantum: self presenter quantum
]

{ #category : #initialization }
SpToploSliderAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	self presenter whenMinChangedDo: [ :newValue |
			self widget minValue: newValue.
			self updateWidgetValue ].
	self presenter whenMaxChangedDo: [ :newValue |
			self widget maxValue: newValue.
			self updateWidgetValue ].
	self presenter whenQuantumChangedDo: [ :newValue |
			self widget quantum: newValue.
			self updateWidgetValue ].
	self presenter whenLabelChangedDo: [ :newLabel | self widget labelText: newLabel ].
	self presenter whenAbsoluteValueChangedDo: [ self updateWidgetValue ]
]

{ #category : #updating }
SpToploSliderAdapter >> updateWidgetValue [

	self widget setValue: self scaledPresenterValue
]

{ #category : #debug }
SpToploSliderAdapter >> widgetAbsoluteValue [

	| current total |
	current := self widget currentValue - self widget minValue.
	total := self widget maxValue - self widget minValue.
	^ (current / total) asFloat
]

{ #category : #debug }
SpToploSliderAdapter >> widgetLabel [

	^ self widget labelText ifNil: [ '' ]
]

{ #category : #debug }
SpToploSliderAdapter >> widgetValue [
	^ self widget currentValue
]

{ #category : #debug }
SpToploSliderAdapter >> widgetValue: aNumber [
	"Emulate a change in the widget value, as if the user moved the knob"

	self widget currentValue: (self round: aNumber toQuantum: self widget quantum)
]
