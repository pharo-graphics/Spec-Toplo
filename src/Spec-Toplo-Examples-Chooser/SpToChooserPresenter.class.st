Class {
	#name : #SpToChooserPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'chooser'
	],
	#category : #'Spec-Toplo-Examples-Chooser'
}

{ #category : #'as yet unclassified' }
SpToChooserPresenter class >> openInToplo [

	<script>
	| app chooser |
	app := SpApplication new
		       useBackend: #Toplo;
		       yourself.


	chooser := self newApplication: app.
	chooser open
]

{ #category : #layout }
SpToChooserPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #chooser;
		  yourself
]

{ #category : #initialization }
SpToChooserPresenter >> initializePresenters [

	chooser := SpChooserPresenter
		           sourceItems: {
				           SpChooserPresenter.
				           SpFilteringListPresenter }
		           chosenItems: { SpFilteringSelectableListPresenter }
		           displayBlock: #name
]
