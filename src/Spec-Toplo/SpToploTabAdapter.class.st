Class {
	#name : #SpToploTabAdapter,
	#superclass : #SpToploLayoutAdapter,
	#instVars : [
		'lastPresenter',
		'constraintsByPresenter'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #adding }
SpToploTabAdapter >> add: aPresenter constraints: constraints [

	aPresenter owner: self presenter.
	constraintsByPresenter at: aPresenter put: constraints.
	self widget addTabItemData: aPresenter
]

{ #category : #accessing }
SpToploTabAdapter >> children [

	^ self widget items collection
]

{ #category : #factory }
SpToploTabAdapter >> embeddableWidgetFor: aPresenter withConstraints: constraints [

	| widget |
	widget := self ensurePresenterBuilt: aPresenter withConstraints: constraints.
	(widget isKindOf: BlElement) ifTrue: [ ^ widget ].
	((widget respondsTo: #root) and: [ widget root isNotNil ]) ifTrue: [ ^ widget root ].
	^ widget
]

{ #category : #factory }
SpToploTabAdapter >> ensureLabelBuilt: aPresenter [

	aPresenter hasAdapter ifFalse: [
		aPresenter hasOwner ifFalse: [ aPresenter owner: self presenter ].
		aPresenter build ].
	^ aPresenter adapter widget
]

{ #category : #factory }
SpToploTabAdapter >> ensurePresenterBuilt: aPresenter withConstraints: constraints [

	(aPresenter hasAdapter and: [ aPresenter owner = self presenter ]) ifFalse: [
		aPresenter owner: self presenter.
		aPresenter buildWithSelector: constraints spec ].
	^ aPresenter adapter widget
]

{ #category : #protocol }
SpToploTabAdapter >> layout: aLayout [

	super layout: aLayout.
	constraintsByPresenter := IdentityDictionary new.

	aLayout children do: [ :each |
		self add: each constraints: (aLayout constraintsFor: each) ].

	(aLayout initialPageIndex between: 1 and: aLayout children size) ifTrue: [
		| aPresenter |
		aPresenter := aLayout children at: aLayout initialPageIndex.
		lastPresenter := aPresenter.
		aLayout announce: (SpTabSelected newPresenter: aPresenter).
		self selectIndex: aLayout initialPageIndex ]
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
			content := self embeddableWidgetFor: aPresenter withConstraints: constraints.
			((pane children size = 1) and: [ pane children first == content ]) ifFalse: [
				content parent ifNotNil: [ content removeFromParent ].
				pane removeChildren.
				pane addChild: content ] ] ].
	^ tabPanel
]

{ #category : #removing }
SpToploTabAdapter >> remove: aPresenter [
	| tabButton |

	constraintsByPresenter removeKey: aPresenter ifAbsent: [  ].
	tabButton := self widget items collection
		detect: [ :each | (each userData at: #adapterPresenter ifAbsent: [ nil ]) = aPresenter ]
		ifNone: [ nil ].
	tabButton ifNotNil: [ self widget removeItem: tabButton ]
]

{ #category : #accessing }
SpToploTabAdapter >> selectIndex: aNumber [

	self widget selectedAtPosition: aNumber
]

{ #category : #factory }
SpToploTabAdapter >> tabLabelFor: anObject [

	anObject ifNil: [ ^ ToLabel text: '' ].
	anObject isPresenter ifTrue: [ ^ self ensureLabelBuilt: anObject ].
	(anObject isKindOf: BlElement) ifTrue: [ ^ anObject ].
	^ ToLabel text: anObject asString
]
