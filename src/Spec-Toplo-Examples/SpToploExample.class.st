Class {
	#name : #SpToploExample,
	#superclass : #Object,
	#category : #'Spec-Toplo-Examples'
}

{ #category : #accessing }
SpToploExample class >> applicationForExamples [
	"Answer an application configured with Toplo backend for examples,
	 reusing the running IDE session application if it already uses Toplo."

	| app |
	app := StPharoApplication current.
	(app backend class = SpToploBackend) ifTrue: [ ^ app ].

	^ StPharoApplication new
		useBackend: #Toplo;
		yourself
]

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
	<script>

	| aDebugSession |
	aDebugSession := StTestDebuggerProvider new sessionForDebuggerTests.
	(self applicationForExamples instantiate: StDebugger on: aDebugSession) open
]

{ #category : #'user interface' }
SpToploExample class >> openToDrTests [
	<script>

	(self applicationForExamples instantiate: DrTests) open
]

{ #category : #'user interface' }
SpToploExample class >> openToFinder [
	<script>

	StFinderPresenter openInToplo
]

{ #category : #'user interface' }
SpToploExample class >> openToIceberg [
	<script>

	| repositories |
	repositories := IceTipRepositoriesBrowser new.
	repositories application: self applicationForExamples.
	repositories open
]

{ #category : #'user interface' }
SpToploExample class >> openToInspector [
	<script>

	(self applicationForExamples instantiate: StInspectorPresenter on: Object new) open
]

{ #category : #'user interface' }
SpToploExample class >> openToPlayground [
	<script>

	(self applicationForExamples instantiate: StPlaygroundPresenter) open
]
