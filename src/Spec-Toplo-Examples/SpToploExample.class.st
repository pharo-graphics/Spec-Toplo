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
SpToploExample class >> openToAthens [
	<script>

	| presenter window |
	presenter := self applicationForExamples instantiate: SpAthensPresenter.
	presenter drawBlock: [ :canvas :bounds |
		| surface grad |
		surface := canvas surface.
		surface clear: Color black.

		"Background gradient"
		grad := surface
			createLinearGradient: {
				(0.0 -> Color purple).
				(0.5 -> Color blue muchDarker).
				(1.0 -> Color cyan muchDarker) }
			start: bounds origin
			stop: bounds corner.
		canvas setPaint: grad.
		canvas drawShape: (bounds insetBy: 16).

		"Dashed stylish border"
		(canvas setStrokePaint: Color white)
			width: 2.5;
			capRound;
			joinRound;
			dashes: #(12 6) offset: 0.
		canvas drawShape: (bounds insetBy: 16).

		"Centered vector text"
		canvas pathTransform restoreAfter: [
			canvas pathTransform translateBy: bounds center.
			canvas setPaint: Color white.
			canvas setFont: StandardFonts defaultFont.
			canvas drawString: 'Hello' ] ].

	window := presenter asWindow.
	window
		title: 'Athens in Toplo Demo';
		initialExtent: 400 @ 300;
		open.

	^ window
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
