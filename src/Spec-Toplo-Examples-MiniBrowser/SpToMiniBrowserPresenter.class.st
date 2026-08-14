"
A small Spec browser running on the Toplo backend.

It is inspired by ToExMiniBrowser, but uses Spec presenters instead of building the widget tree directly with Toplo elements.
"
Class {
	#name : #SpToMiniBrowserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'packageTree',
		'classTree',
		'protocolList',
		'selectorList',
		'codePresenter',
		'classSideCheckBox',
		'statusBar',
		'classSide'
	],
	#category : #'Spec-Toplo-Examples-MiniBrowser-Presenters'
}

{ #category : #'user interface' }
SpToMiniBrowserPresenter class >> menuExamplesOn: aBuilder [
	"Add the mini browser to the world menu."

	<worldMenu>
	(aBuilder item: #'Spec-Toplo mini browser')
		iconName: #smallHelp;
		parent: #'Spec-Toplo demo';
		order: 99998;
		help: 'Open the Spec-Toplo mini browser.';
		action: [ self openInToplo ]
]

{ #category : #opening }
SpToMiniBrowserPresenter class >> openIn: aBackendSymbol [

	| app browser |
	app := SpApplication new
		       useBackend: aBackendSymbol;
		       yourself.
	browser := self newApplication: app.
	browser open.
	^ browser
]

{ #category : #opening }
SpToMiniBrowserPresenter class >> openInMorphic [

	<script>
	^ self openIn: #Morphic
]

{ #category : #opening }
SpToMiniBrowserPresenter class >> openInToplo [

	<script>
	^ self openIn: #Toplo
]

{ #category : #'private - classes' }
SpToMiniBrowserPresenter >> behaviorForClass: aClass [

	classSide ifTrue: [ ^ aClass class ].
	^ aClass
]

{ #category : #'private - packages' }
SpToMiniBrowserPresenter >> childrenOfPackageTreeItem: anItem [

	((anItem respondsTo: #isPackage) and: [ anItem isPackage ]) ifFalse: [
		^ #(  ) ].
	^ (anItem tags asSortedCollection: [ :a :b | a name < b name ])
		  asArray
]

{ #category : #layout }
SpToMiniBrowserPresenter >> classColumnLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 3;
		  add: 'Classes' expand: false;
		  add: #classTree;
		  add: #classSideCheckBox expand: false;
		  yourself
]

{ #category : #selection }
SpToMiniBrowserPresenter >> classSelectionChanged [

	self refreshProtocolListFromSelectedClass.
	codePresenter model selectedBehavior: classTree selectedItem
]

{ #category : #'private - refreshing' }
SpToMiniBrowserPresenter >> clearCodePresenter [

	codePresenter ifNil: [ ^ self ].
	codePresenter
				clearInteractionModel
]

{ #category : #'private - refreshing' }
SpToMiniBrowserPresenter >> clearProtocolAndSelectorLists [

	protocolList items: #(  ).
	selectorList items: #(  )
]

{ #category : #initialization }
SpToMiniBrowserPresenter >> connectPresenters [

	super connectPresenters.
	packageTree whenSelectionChangedDo: [ :aSelection |
		self packageSelectionChanged ].
	classTree whenSelectionChangedDo: [ :aSelection |
		self classSelectionChanged ].
	protocolList whenSelectionChangedDo: [ :aSelection |
		self protocolSelectionChanged ].
	selectorList whenSelectionChangedDo: [ :aSelection |
		self selectorSelectionChanged ].
	classSideCheckBox whenChangedDo: [ :aBoolean |
			classSide := aBoolean.
			self refreshProtocolListFromSelectedClass ]
]

{ #category : #layout }
SpToMiniBrowserPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  borderWidth: 5;
		  spacing: 5;
		  add: (SpPanedLayout newTopToBottom
				   positionOfSlider: 45 percent;
				   add: self listsLayout;
				   add: #codePresenter;
				   yourself);
		  yourself
]

{ #category : #'private - packages' }
SpToMiniBrowserPresenter >> displayNameOfPackageTreeItem: anItem [

	(anItem respondsTo: #name) ifTrue: [ ^ anItem name ].
	^ anItem asString
]

{ #category : #initialization }
SpToMiniBrowserPresenter >> initialize [
	super initialize.
	
]

{ #category : #initialization }
SpToMiniBrowserPresenter >> initializePresenters [

	super initializePresenters.
	classSide := false.


	packageTree := self newTree
		               roots: self sortedPackages;
		               children: [ :anItem | self childrenOfPackageTreeItem: anItem ];
		               display: [ :anItem | self displayNameOfPackageTreeItem: anItem ];
		               yourself.

	classTree := self newTree
		             children: [ :aClass | self sortedSubclassesOf: aClass ];
		             display: [ :aClass | aClass name ];
		             displayIcon: [ :aClass | self iconNamed: aClass systemIconName ];
		             yourself.

	protocolList := self newList
		                display: [ :anAssociation | anAssociation value name ];
		                yourself.

	selectorList := self newList
		                display: [ :anAssociation | anAssociation value asString ];
		                yourself.

	codePresenter := SpToMiniBrowserEditorPresenter on: SpToMiniBrowserEditorModel new.

	classSideCheckBox := self newCheckBox
		                     label: 'Class side';
		                     state: classSide;
		                     yourself.

	statusBar := self newStatusBar.
	self refreshStatus
]

{ #category : #initialization }
SpToMiniBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Spec-Toplo Mini Browser';
		initialExtent: 1000 @ 650;
		centered;
		statusbar: statusBar
]

{ #category : #layout }
SpToMiniBrowserPresenter >> listsLayout [

	^ SpBoxLayout newLeftToRight
		  beHomogeneous;
		  spacing: 5;
		  add: self packageColumnLayout;
		  add: self classColumnLayout;
		  add: self protocolColumnLayout;
		  add: self selectorColumnLayout;
		  yourself
]

{ #category : #layout }
SpToMiniBrowserPresenter >> packageColumnLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 3;
		  add: 'Packages' expand: false;
		  add: #packageTree;
		  yourself
]

{ #category : #selection }
SpToMiniBrowserPresenter >> packageSelectionChanged [

	| selectedItem |
	selectedItem := packageTree selectedItem.
	classTree roots: (selectedItem
			 ifNil: [ #(  ) ]
			 ifNotNil: [ self sortedClassesInPackageTreeItem: selectedItem ]).
	self clearProtocolAndSelectorLists.
	self clearCodePresenter.
	self refreshStatus
]

{ #category : #'private - classes' }
SpToMiniBrowserPresenter >> protocolAssociationsForClass: aClass [

	| behavior |
	behavior := self behaviorForClass: aClass.
	^ (behavior protocols collect: [ :aProtocol | behavior -> aProtocol ])
		  asArray
]

{ #category : #layout }
SpToMiniBrowserPresenter >> protocolColumnLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 3;
		  add: 'Protocols' expand: false;
		  add: #protocolList;
		  yourself
]

{ #category : #selection }
SpToMiniBrowserPresenter >> protocolSelectionChanged [

	| selectedProtocol selectors |
	self clearCodePresenter.
	selectedProtocol := protocolList selectedItem.
	selectedProtocol ifNil: [
			selectorList items: #(  ).
			self refreshStatus.
			^ self ].
	selectors := selectedProtocol value methodSelectors
		             asSortedCollection collect: [ :selector |
		             selectedProtocol key -> selector ].
	selectorList items: selectors asArray.
	self refreshStatus
]

{ #category : #selection }
SpToMiniBrowserPresenter >> refreshProtocolListFromSelectedClass [

	| selectedClass protocols |
	selectorList items: #(  ).
	self clearCodePresenter.
	selectedClass := classTree selectedItem.
	selectedClass ifNil: [
			protocolList items: #(  ).
			self refreshStatus.
			^ self ].
	protocols := self protocolAssociationsForClass: selectedClass.
	protocolList items:
		(protocols asSortedCollection: [ :a :b |
			 a value name < b value name ]) asArray.
	self refreshStatus
]

{ #category : #'private - refreshing' }
SpToMiniBrowserPresenter >> refreshStatus [

	| packageCount classCount protocolCount selectorCount selectedClass classLabel sideLabel |
	statusBar ifNil: [ ^ self ].
	packageCount := packageTree
		                ifNil: [ 0 ]
		                ifNotNil: [ packageTree roots size ].
	classCount := classTree
		              ifNil: [ 0 ]
		              ifNotNil: [ classTree roots size ].
	protocolCount := protocolList
		                 ifNil: [ 0 ]
		                 ifNotNil: [ protocolList items size ].
	selectorCount := selectorList
		                 ifNil: [ 0 ]
		                 ifNotNil: [ selectorList items size ].
	selectedClass := classTree
		                 ifNil: [ nil ]
		                 ifNotNil: [ classTree selectedItem ].
	sideLabel := classSide
		             ifTrue: [ 'class side' ]
		             ifFalse: [ 'instance side' ].
	classLabel := selectedClass
		              ifNil: [ 'No class selected' ]
		              ifNotNil: [ selectedClass name , ' - ' , sideLabel ].
	statusBar pushMessage:
		('{1} packages | {2} classes | {3} protocols | {4} selectors | {5}'
			 format: {
					 packageCount.
					 classCount.
					 protocolCount.
					 selectorCount.
					 classLabel })
]

{ #category : #layout }
SpToMiniBrowserPresenter >> selectorColumnLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 3;
		  add: 'Selectors' expand: false;
		  add: #selectorList;
		  yourself
]

{ #category : #selection }
SpToMiniBrowserPresenter >> selectorSelectionChanged [

	| selectedSelector |
	selectedSelector := selectorList selectedItem.
	selectedSelector
		ifNil: [ self clearCodePresenter ]
		ifNotNil: [ self showSourceForSelectorAssociation: selectedSelector ].
	self refreshStatus
]

{ #category : #'private - refreshing' }
SpToMiniBrowserPresenter >> showSourceForSelectorAssociation: anAssociation [

	codePresenter setMethod: anAssociation
]

{ #category : #'private - packages' }
SpToMiniBrowserPresenter >> sortedClassesInPackageTreeItem: anItem [

	| classes |
	classes := ((anItem respondsTo: #isPackage) and: [ anItem isPackage ])
		           ifTrue: [ anItem definedClasses ]
		           ifFalse: [ anItem classes ].
	^ (classes asSortedCollection: [ :a :b | a name < b name ]) asArray
]

{ #category : #'private - packages' }
SpToMiniBrowserPresenter >> sortedPackages [

	^ (self packageOrganizer packages asSortedCollection: [ :a :b |
		   a name < b name ]) asArray
]

{ #category : #'private - classes' }
SpToMiniBrowserPresenter >> sortedSubclassesOf: aClass [

	^ (aClass subclasses asSortedCollection: [ :a :b | a name < b name ])
		  asArray
]
