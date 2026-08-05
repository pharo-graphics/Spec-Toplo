Class {
	#name : #SpToMiniBrowserEditorPresenter,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'notebook',
		'methodCodePage',
		'behaviorCodePage'
	],
	#category : #'Spec-Toplo-Examples-MiniBrowser-Presenters'
}

{ #category : #api }
SpToMiniBrowserEditorPresenter >> clearInteractionModel [

	self model selectedMethod: nil
]

{ #category : #layout }
SpToMiniBrowserEditorPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: #notebook;
		  yourself
]

{ #category : #layout }
SpToMiniBrowserEditorPresenter >> initializeClassCodePage [

	behaviorCodePage presenterProvider: [
			| codePresenter |
			codePresenter := self newCode.
			self model whenSelectedBehaviorChangedDo: [ :behavior |
					behavior
						ifNil: [
								behaviorCodePage title: 'New Class'.
								codePresenter userActionDuring: [
										codePresenter text: 'Object << #MyClass
	slots: {};
	package: ''_Unpackaged''' ] ]
						ifNotNil: [
								behaviorCodePage title: behavior printString.
								codePresenter text: behavior definitionString copy ] ].
			codePresenter ].
	self setBehaviorCodePage: nil
]

{ #category : #layout }
SpToMiniBrowserEditorPresenter >> initializeMethodCodePage [

	methodCodePage title: ''.

	self model whenSelectedMethodChangedDo: [ :method |
			method
				ifNil: [
						notebook selectPage: behaviorCodePage.
						(notebook pages includes: methodCodePage) ifTrue: [ notebook removePage: methodCodePage ] ]
				ifNotNil: [
						methodCodePage title: method selector.

						(notebook pages includes: methodCodePage)
							ifFalse: [ notebook addPage: methodCodePage ]
							ifTrue: [  methodCodePage resetContent ].
						notebook selectPage: methodCodePage ] ].


	methodCodePage presenterProvider: [
			| sourceText codePresenter |
			codePresenter := self newCode.
			sourceText := self model selectedBehavior sourceCodeAt: self model selectedMethod selector ifAbsent: [ '' ].

			codePresenter userActionDuring: [
					codePresenter beForBehavior: self model selectedBehavior.
					codePresenter text: sourceText copy ].
			codePresenter ].
	^ methodCodePage
]

{ #category : #initialization }
SpToMiniBrowserEditorPresenter >> initializePresenters [

	super initializePresenters.
	notebook := self newNotebook.
	methodCodePage := self newNotebookPage.
	behaviorCodePage := self newNotebookPage.
	notebook addPage: behaviorCodePage.
	notebook addPage: methodCodePage.
	
	notebook selectPage: behaviorCodePage.
	self initializeClassCodePage.
	self initializeMethodCodePage.
]

{ #category : #api }
SpToMiniBrowserEditorPresenter >> setBehaviorCodePage: aBehaviorOrNil [

	self model selectedBehavior: aBehaviorOrNil.
	self setSelectedMethod: nil
]

{ #category : #layout }
SpToMiniBrowserEditorPresenter >> setMethod: anAssociationClassSelector [

	| behavior selector |
	behavior := anAssociationClassSelector key.
	selector := anAssociationClassSelector value.
	self model selectedBehavior: behavior.
	self model selectedMethod: behavior >> selector
]

{ #category : #api }
SpToMiniBrowserEditorPresenter >> setSelectedMethod: aMethod [

	self model selectedMethod: aMethod
]
