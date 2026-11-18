"
I'm a Spec adapter for `SpNotebookPresenter`.
"
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

			aData whenTitleChangedDo: [ :newTitle |
				tabButton label text: newTitle ].

			tabButton paneBuilder: [ :pane |
				pane addChild: (self buildContentForPage: aData) ] ].
	model pages do: [ :page | tabPanel addTabItemData: page ].

	"force first page to be drawn"
	model selectedPage ifNil: [ "cannot select a page if there is not"
		model pages ifNotEmpty: [
			model selectPageIndex: 1 ] ].

	tabPanel selecter selectIndex: model selectedPageIndex.
	tabPanel requestFocus.
	^ tabPanel
]

{ #category : #test }
SpToploNotebookAdapter >> clickTab: anInteger [

	(widget dataSource at: anInteger) eventSimulator click
]

{ #category : #factory }
SpToploNotebookAdapter >> ensurePage: aPage isBuiltWithPresenter: presenter [

	"is already built *for this notebook (owner)*"
	(presenter hasAdapter and: [ presenter owner = model ]) 
		ifTrue: [ ^ self ].

	"if not built or not same owner, I need to rebuild"
	presenter owner: model.
	presenter build

]

{ #category : #factory }
SpToploNotebookAdapter >> modelOfTab: tabButton [

	^ tabButton userData at: #adapterTabModel ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
SpToploNotebookAdapter >> numberOfTabs [
	^ widget dataSource size
]

{ #category : #factory }
SpToploNotebookAdapter >> pageWithModel: anObject [
	"an utility to easy find pages with a model"
 
	^ widget dataSource collection detect: [ :tabButton |
			 (self modelOfTab: tabButton) = anObject ]
]

{ #category : #factory }
SpToploNotebookAdapter >> selectPage: page [
	"page can be nil if delete all pages"

	"SpNotebookAdapterTest>>#testRemoveAll"

	page ifNil: [ ^ nil ].
	widget selectedAtPosition:
		(widget dataSource collection detect: [ :tabButton |
			 (self modelOfTab: tabButton) = page ]) holder position
]

{ #category : #'inspector compatibility' }
SpToploNotebookAdapter >> selectedPageName [

	^ (widget dataSource at: widget selecter selectedIndex)
		  labelText
]

{ #category : #initialization }
SpToploNotebookAdapter >> subscribeToPresenter [

	super subscribeToPresenter.
	model
		whenPagesChangedDo: [ :pages | self updatePagesWith: pages ];
		whenSelectedPageChangedDo: [ :page | self selectPage: page ];
		whenPageRemovedDo: [ :page | "" ]
]

{ #category : #initialization }
SpToploNotebookAdapter >> subscribeToWidget [

	super subscribeToWidget.
	self
		subscribeToWidgetEvent: ToListPrimarySelectionChangedEvent
		on: widget itemList
		do: [ :event |
			event selectedIndexes
				ifEmpty: [ model selectPage: nil ]
				ifNotEmpty: [
					model selectPage:
						(self modelOfTab:
							(widget dataAccessor at: event selectedIndexes first)) ] ]
]

{ #category : #updating }
SpToploNotebookAdapter >> updatePageContent: aPage [

	(self pageWithModel: aPage) invalidate.
	aPage = model selectedPage ifFalse: [ ^ self ].
	self updatePageIndex: model selectedPageIndex
]

{ #category : #private }
SpToploNotebookAdapter >> updatePageIndex: anInteger [

	| newPage widgetPage |

	newPage := model pages at: anInteger.
	widgetPage := self widgetPageAtIndex: anInteger.
	widgetPage paneBuilder: [ :pane | pane addChild: (self buildContentForPage: newPage) ].
	widgetPage bodyPane: nil.
	widget itemList dataSource notifyChanged.
	(widget itemList isSelectedAtPosition: anInteger) ifFalse: [ ^ self ].
	widget body removeChildren.
	(widgetPage paneBuilder value: widget body)
]

{ #category : #factory }
SpToploNotebookAdapter >> updatePagesWith: aCollection [

	| pagesToRemove |
	widget ifNil: [ ^ self ].

	pagesToRemove := widget dataAccessor reject: [ :tabButton |
		                 aCollection anySatisfy: [ :page | page = (self modelOfTab: tabButton) ] ].
	pagesToRemove do: [ :tabButton | widget removeItem: tabButton ].
	aCollection
		reject: [ :page | widget dataAccessor anySatisfy: [ :p | (self modelOfTab: p) = page ] ]
		thenDo: [ :page | widget addTabItemData: page ]
]

{ #category : #initialization }
SpToploNotebookAdapter >> widgetPageAtIndex: anIndex [

	^ widget dataAccessor at: anIndex
]
