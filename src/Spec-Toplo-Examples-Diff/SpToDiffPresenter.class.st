Class {
	#name : #SpToDiffPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'diff'
	],
	#category : #'Spec-Toplo-Examples-Diff'
}

{ #category : #layout }
SpToDiffPresenter class >> openInToplo [

	<script>
	| app chooser |
	app := SpApplication new
		       useBackend: #Toplo;
		       yourself.


	chooser := self newApplication: app.
	chooser open.
	^ chooser
]

{ #category : #layout }
SpToDiffPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #diff;
		  yourself
]

{ #category : #initialization }
SpToDiffPresenter >> initializePresenters [

	diff := SpDiffPresenter new
		        showOptions: false;
		        leftText: 'Old text';
		        rightText: 'New text';
		        leftLabel: 'Source';
		        rightLabel: 'Target'
]
