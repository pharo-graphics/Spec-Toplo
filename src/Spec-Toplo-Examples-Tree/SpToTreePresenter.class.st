Class {
	#name : #SpToTreePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tree'
	],
	#category : #'Spec-Toplo-Examples-Tree'
}

{ #category : #layout }
SpToTreePresenter class >> openInToplo [

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
SpToTreePresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #tree;
		  yourself
]

{ #category : #layout }
SpToTreePresenter >> initializePresenters [

	tree := self newTree
		             roots: { SpPresenter };
		             children: [ :aClass | aClass subclasses ];
		             yourself
]
