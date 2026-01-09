Class {
	#name : #SpToploNotebookAdapter,
	#superclass : #SpToploWidgetAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploNotebookAdapter >> addModel: aData to: tabButton [

	tabButton userData at: #adapterTabModel put: aData
]

{ #category : #factory }
SpToploNotebookAdapter >> buildContentForPage: aPage [

	^ aPage retrievePresenter ifNotNil: [ :presenter |
			  self ensurePage: aPage isBuiltWithPresenter: presenter.
			  presenter adapter widget ]
]

{ #category : #factory }
SpToploNotebookAdapter >> buildWidget [

	| tabPanel |
	tabPanel := ToTabPaneElement new.
	"default value in morphic"
	tabPanel vertical: true.
	tabPanel itemBuilder: [ :tabButton :aData :holder |
			tabButton removable: aData isCloseable.
			tabButton label: (ToLabel text: aData title asString).
			self addModel: aData to: tabButton.
			tabButton userData at: #adapterTabModel put: aData.
			tabButton paneBuilder: [ :pane |
				pane addChild: (self buildContentForPage: aData) ] ].
	self presenter pages do: [ :page | tabPanel addTabItemData: page ].

	self presenter selectedPageIndex ~= 0
		ifTrue: [
		tabPanel selectedAtPosition: self presenter selectedPageIndex ]
		ifFalse: [ tabPanel selectedAtPosition: 1 ].
	self presenter
		whenPagesChangedDo: [ :pages | self updatePagesWith: pages ];
		whenSelectedPageChangedDo: [ :page | self selectPage: page ].
	^ tabPanel
]

{ #category : #factory }
SpToploNotebookAdapter >> ensurePage: aPage isBuiltWithPresenter: presenter [

	"is already built *for this notebook (owner)*"

	(presenter hasAdapter and: [ presenter owner = self presenter ]) 
		ifTrue: [ ^ self ].

	"if not built or not same owner, I need to rebuild"
	presenter owner: self presenter.
	presenter build

]

{ #category : #factory }
SpToploNotebookAdapter >> modelOfTab: tabButton [

	^ tabButton userData at: #adapterTabModel ifAbsent: [ nil ]
]

{ #category : #factory }
SpToploNotebookAdapter >> selectPage: page [

	self widget selectedAtPosition:
		(self widget items collection detect: [ :tabButton |
			 (self modelOfTab: tabButton) = page ]) holder position
]

{ #category : #factory }
SpToploNotebookAdapter >> updatePagesWith: aCollection [

	| pagesToRemove |
	self widget ifNil: [ ^ self ].

	pagesToRemove := self widget items collection reject: [ :tabButton |
		                 aCollection anySatisfy: [ :page |
			                 page = (self modelOfTab: tabButton) ] ].
	pagesToRemove do: [ :tabButton | self widget removeItem: tabButton ].
	aCollection
		reject: [ :page |
				self widget items collection anySatisfy: [ :p |
					(self modelOfTab: p) = page ] ]
		thenDo: [ :page | self widget addTabItemData: page ]
]
