Class {
	#name : #SpToploExample,
	#superclass : #Object,
	#category : #'Spec-Toplo-Examples'
}

{ #category : #'user interface' }
SpToploExample class >> menuExamplesOn: aBuilder [
	"Add a custom menu item to the world menu"

	<worldMenu>
	(aBuilder item: #'Spec-Toplo demo')
		iconName: #smallHelp;
		parent: #Tools;
		order: 99999;
		help: 'Open Spec-Toplo Browser.';
		with: [
				(aBuilder item: #toInspector) action: [ self openToInspector ].
				(aBuilder item: #toPlayground) action: [ self openToPlayground ].
				(aBuilder item: #toTests) action: [ self openToDrTests ].
				(aBuilder item: #toFinder) action: [ self openToFinder ].
				(aBuilder item: #toGitManager)
					action: [ self openToIceberg ];
					withSeparatorAfter.
					(aBuilder item: #toDebugger)
					action: [ self openToDebugger ];
					withSeparatorAfter ]
]

{ #category : #'user interface' }
SpToploExample class >> openToDebugger [

	| app aDebugSession debugger |
	app := StPharoApplication new.
	app useBackend: #Toplo.

	aDebugSession := StTestDebuggerProvider new sessionForDebuggerTests.
	debugger := StDebugger basicNew
		            session: aDebugSession;
		            application: app;
		            initialize;
		            yourself.

	debugger open
]

{ #category : #'user interface' }
SpToploExample class >> openToDrTests [

	| drTest app |
	app := StPharoApplication new.
	app useBackend: #Toplo.
	drTest := DrTests newApplication: app.
	drTest open
]

{ #category : #'user interface' }
SpToploExample class >> openToFinder [

	StFinderPresenter openInToplo
]

{ #category : #'user interface' }
SpToploExample class >> openToIceberg [

	| repositories app |
	repositories := IceTipRepositoriesBrowser new.
	app := StPharoApplication new.
	app useBackend: #Toplo.
	repositories application: app.
	repositories open
]

{ #category : #'user interface' }
SpToploExample class >> openToInspector [

	| inspector app |
	inspector := StInspectorPresenter onObject: Object new.
	app := StPharoApplication new.
	app useBackend: #Toplo.
	inspector application: app.
	inspector open
]

{ #category : #'user interface' }
SpToploExample class >> openToPlayground [

	| playground app |
	playground := StPlaygroundPresenter new.
	app := StPharoApplication new.
	app useBackend: #Toplo.
	playground application: app.
	playground open
]
