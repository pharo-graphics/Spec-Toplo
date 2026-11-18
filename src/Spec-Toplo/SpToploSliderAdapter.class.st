Class {
	#name : #SpToploSliderAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploSliderAdapter >> buildWidget [

	| slider |
	slider := ToBasicHorizontalSlider new
		          minValue: model min;
		          maxValue: model max;
		          quantum: model quantum;
		          newValueCallback: [ :newValue | model value: newValue ];
		          yourself.
	slider setValue: self scaledPresenterValue.
	slider userData at: #label put: model label.
	^ slider
]

{ #category : #updating }
SpToploSliderAdapter >> scaledPresenterValue [
	"Answer the presenter position (absolute value, 0 to 1) in the min..max range, rounded to the quantum"

	| scaledValue |
	scaledValue := model min + (model absoluteValue * (model max - model min)).
	model quantum ifNotNil: [ :quantum | scaledValue := scaledValue roundTo: quantum ].
	^ scaledValue
]

{ #category : #initialization }
SpToploSliderAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	model whenMinChangedDo: [ :newValue |
			widget minValue: newValue.
			self updateWidgetValue ].
	model whenMaxChangedDo: [ :newValue |
			widget maxValue: newValue.
			self updateWidgetValue ].
	model whenQuantumChangedDo: [ :newValue |
			widget quantum: newValue.
			self updateWidgetValue ].
	model whenLabelChangedDo: [ :newLabel | widget userData at: #label put: newLabel ].
	model whenAbsoluteValueChangedDo: [ self updateWidgetValue ]
]

{ #category : #updating }
SpToploSliderAdapter >> updateWidgetValue [

	widget setValue: self scaledPresenterValue
]

{ #category : #debug }
SpToploSliderAdapter >> widgetAbsoluteValue [

	| current total |
	current := widget currentValue - widget minValue.
	total := widget maxValue - widget minValue.
	^ (current / total) asFloat
]

{ #category : #debug }
SpToploSliderAdapter >> widgetLabel [

	^ widget userData at: #label ifAbsent: [ '' ]
]

{ #category : #debug }
SpToploSliderAdapter >> widgetValue [
	^ widget currentValue
]

{ #category : #debug }
SpToploSliderAdapter >> widgetValue: aNumber [
	"Emulate a change in the widget value, as if the user moved the knob"

	| newValue |
	newValue := widget quantum ifNil: [ aNumber ] ifNotNil: [ :quantum | aNumber roundTo: quantum ].
	widget currentValue: newValue
]
