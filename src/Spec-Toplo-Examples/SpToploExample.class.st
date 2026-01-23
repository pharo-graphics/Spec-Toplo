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
				(aBuilder item: #toPlayground)
					action: [ self openToPlayground ];
					withSeparatorAfter ]
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
