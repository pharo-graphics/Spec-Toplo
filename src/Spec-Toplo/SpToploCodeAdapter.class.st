"
I'm a Spec adapter for `SpCodePresenter`.
"
Class {
	#name : #SpToploCodeAdapter,
	#superclass : #SpToploTextAdapter,
	#instVars : [
		'bindings'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploCodeAdapter >> addTextSegmentDecoration: aDecorationSegment [

	self widgetDo: [ :w |
			| deco |
			deco := (AlbSubtextElement editorElement: w next)
				        interval: aDecorationSegment interval;
				        background: aDecorationSegment highlightColor;
				        yourself.
				w next frontLayer addChild: deco. ]
]

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
SpToploCodeAdapter >> insertPopoverAfterCurrentSelection: aPresenter style: styleName [

	| popover |
	self widgetDo: [ :w |
			popover := self presenter newPopover
				           presenter: aPresenter;
				           yourself.
			popover build.
			styleName ifNotNil: [ popover addStyle: styleName ].
			popover adapter popupWindowHandler placement:
				(ToActionPlacement new action: [ :theWin :evt :aBoundsUpdater |
						 | theElem theRoot |
						 theElem := theWin anchorElement.
						 theRoot := theWin anchorRoot.
						 theWin position:
							 theElem next beneathLayer children first bounds inSpace bounds
								 right
							 @
							 theElem next beneathLayer children first bounds inSpace bounds
								 top ]) ]
]

{ #category : #'updating widget' }
SpToploCodeAdapter >> interactionModel: anInteractionModel [
	"When a new interaction model is set in the presenter, this message is sent to the adapter.
	Note this is an anomaly in the general pattern.
	See: https://github.com/pharo-spec/Spec/issues/1567"

	self updateInteractionModel
]

{ #category : #factory }
SpToploCodeAdapter >> pasteText [

	self widget editor paste
]

{ #category : #removing }
SpToploCodeAdapter >> removeAllTextSegmentDecorations [

	self widgetDo: [ :w | w next frontLayer removeChildren ]
]

{ #category : #initialization }
SpToploCodeAdapter >> subscribeToPresenter [

	super subscribeToPresenter.

	model whenLineNumbersChangedDo: [
		self updateLineNumbers ]
]

{ #category : #protocol }
SpToploCodeAdapter >> takeKeyboardFocus [
	self flag: #toImplement
]

{ #category : #initialization }
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
		isScripting: true;
		classOrMetaClass: nil;
		workspace: self.

	widget requestTextStyle
]

{ #category : #protocol }
SpToploCodeAdapter >> userActionDuring: aBlock [

	aBlock value
]
