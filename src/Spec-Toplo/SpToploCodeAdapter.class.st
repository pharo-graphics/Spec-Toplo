Class {
	#name : #SpToploCodeAdapter,
	#superclass : #SpToploTextAdapter,
	#instVars : [
		'bindings'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #accessing }
SpToploCodeAdapter >> bindings [
	"In scripting interaction model, I set myself as workspace. Responding to this message is needed in consequence."

	^ bindings ifNil: [ bindings := SystemDictionary new ]
]

{ #category : #factory }
SpToploCodeAdapter >> buildWidget [

	^ super buildWidget
		styler: BlPharoCodeStyler new;
		yourself
]

{ #category : #'updating widget' }
SpToploCodeAdapter >> interactionModel: anInteractionModel [
	"When a new interaction model is set in the presenter, this message is sent to the adapter.
	Note this is an anomaly in the general pattern.
	See: https://github.com/pharo-spec/Spec/issues/1567"

	self updateInteractionModel
]

{ #category : #initialization }
SpToploCodeAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenLineNumbersChangedDo: [
		self updateLineNumbers ]
]

{ #category : #'updating widget' }
SpToploCodeAdapter >> updateAll [

	super updateAll.

	self
		updateLineNumbers;
		updateInteractionModel
]

{ #category : #'updating widget' }
SpToploCodeAdapter >> updateInteractionModel [

	model interactionModel isScripting
		ifTrue: [ self updateStylerForScripting ]
		ifFalse: [ self updateStylerFor: model interactionModel behavior ]
]

{ #category : #'updating widget' }
SpToploCodeAdapter >> updateLineNumbers [

	model hasLineNumbers
		ifTrue: [ widget withRowNumbers ]
		ifFalse: [ widget withoutRowNumbers ]
]

{ #category : #'updating widget' }
SpToploCodeAdapter >> updateStylerFor: aBehavior [

	widget styler
		isForWorkspace: false;
		classOrMetaClass: aBehavior.

	widget requestTextStyle
]

{ #category : #'updating widget' }
SpToploCodeAdapter >> updateStylerForScripting [

	widget styler
		isForWorkspace: true;
		classOrMetaClass: nil;
		workspace: self.

	widget requestTextStyle
]
