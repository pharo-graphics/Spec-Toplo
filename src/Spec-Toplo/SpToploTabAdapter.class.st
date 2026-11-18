Class {
	#name : #SpToploTabAdapter,
	#superclass : #SpToploLayoutAdapter,
	#instVars : [
		'lastPresenter',
		'constraintsByPresenter'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTabAdapter >> adapterWasBuilt [

	| initialPageIndex presenterToSelect |
	super adapterWasBuilt.
	initialPageIndex := layout initialPageIndex.
	(initialPageIndex between: 1 and: layout children size) ifFalse: [ ^ self ].
	presenterToSelect := layout children at: initialPageIndex.
	lastPresenter := presenterToSelect.
	layout announce: (SpTabSelected newPresenter: presenterToSelect).
	self selectIndex: initialPageIndex
]

{ #category : #adding }
SpToploTabAdapter >> add: aPresenter constraints: constraints [

	aPresenter owner: model.
	constraintsByPresenter at: aPresenter put: constraints.
	widget addTabItemData: aPresenter
]

{ #category : #accessing }
SpToploTabAdapter >> children [

	^ widget items collection
]

{ #category : #factory }
SpToploTabAdapter >> embeddableWidgetFor: aPresenter withConstraints: constraints [

	self
		ensurePresenterBuilt: aPresenter
		withConstraints: constraints.
	^ aPresenter adapter widgetElement
]

{ #category : #factory }
SpToploTabAdapter >> ensureLabelBuilt: aPresenter [

	aPresenter hasAdapter ifFalse: [
			aPresenter hasOwner ifFalse: [ aPresenter owner: model ].
			aPresenter build ].
	^ aPresenter adapter widget
]

{ #category : #factory }
SpToploTabAdapter >> ensurePresenterBuilt: aPresenter withConstraints: constraints [

	(aPresenter hasAdapter and: [ aPresenter owner = model ]) ifFalse: [
		aPresenter owner: model.
		aPresenter buildWithSelector: constraints spec ].
	^ aPresenter adapter widget
]

{ #category : #protocol }
SpToploTabAdapter >> layout: aLayout [

	super layout: aLayout.
	constraintsByPresenter := IdentityDictionary new
]

{ #category : #'instance creation' }
SpToploTabAdapter >> newToploWidget [

	| tabPanel |
	tabPanel := ToTabPaneElement new.
	tabPanel vertical: true.
	tabPanel itemBuilder: [ :tabButton :aPresenter :holder |
			| constraints tabLabel content |
			constraints := constraintsByPresenter at: aPresenter.
			tabButton userData at: #adapterPresenter put: aPresenter.
			tabLabel := self tabLabelFor: constraints label.
			tabButton label == tabLabel ifFalse: [
					tabLabel parent ifNotNil: [ tabLabel removeFromParent ].
					tabButton label: tabLabel ].
			tabButton paneBuilder: [ :pane |
					content := self
						           embeddableWidgetFor: aPresenter
						           withConstraints: constraints.
					(pane children size = 1 and: [ pane children first == content ])
						ifFalse: [
								content parent ifNotNil: [ content removeFromParent ].
								pane removeChildren.
								pane addChild: content ] ] ].
	^ tabPanel
]

{ #category : #adding }
SpToploTabAdapter >> remove: aPresenter [
	| tabButton |

	constraintsByPresenter removeKey: aPresenter ifAbsent: [  ].
	tabButton := widget items collection
		detect: [ :each | (each userData at: #adapterPresenter ifAbsent: [ nil ]) = aPresenter ]
		ifNone: [ nil ].
	tabButton ifNotNil: [ widget removeItem: tabButton ]
]

{ #category : #accessing }
SpToploTabAdapter >> selectIndex: aNumber [

	widget selectedAtPosition: aNumber
]

{ #category : #factory }
SpToploTabAdapter >> tabLabelFor: anObject [

	anObject ifNil: [ ^ ToLabel text: '' ].
	anObject isPresenter ifTrue: [ ^ self ensureLabelBuilt: anObject ].
	(anObject isKindOf: BlElement) ifTrue: [ ^ anObject ].
	^ ToLabel text: anObject asString
]
