"
I'm a Spec adapter for `SpLabelPresenter`.
"
Class {
	#name : #SpToploLabelAdapter,
	#superclass : #SpToploWidgetAdapter,
	#traits : 'SpToploTWithContextMenu',
	#classTraits : 'SpToploTWithContextMenu classTrait',
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #accessing }
SpToploLabelAdapter >> backgroundColor [

	^ self widget attributesBuilder attributes
		  detect: [ :att | att isKindOf: BlTextBackgroundAttribute ]
		  ifFound: [ :attribute | attribute paint ]
		  ifNone: [ ^ nil ]
]

{ #category : #accessing }
SpToploLabelAdapter >> beJustifyCenter [
	"not implemented yet"
]

{ #category : #accessing }
SpToploLabelAdapter >> beWrap [
	self widget beMultiLine
]

{ #category : #factory }
SpToploLabelAdapter >> buildWidget [

	^ ToLabel new
]

{ #category : #accessing }
SpToploLabelAdapter >> font [
	
	^ self notYetImplemented
]

{ #category : #accessing }
SpToploLabelAdapter >> label [
	
	^ widget text asString
]

{ #category : #initialization }
SpToploLabelAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	
	model whenLabelChangedDo: [ self updateLabel ]
]

{ #category : #initialization }
SpToploLabelAdapter >> updateAll [

	super updateAll.

	self
		updateLabel;
		updateMenu;
		updateBackgroundColor
]

{ #category : #'updating widget' }
SpToploLabelAdapter >> updateBackgroundColor [

	self model displayBackgroundColor ifNotNil: [ :backgroundColorAction |
		self widget attributesBuilder background: backgroundColorAction value ]
]

{ #category : #'updating widget' }
SpToploLabelAdapter >> updateLabel [

	widget text: model label
]
