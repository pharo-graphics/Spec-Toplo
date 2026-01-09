Class {
	#name : #SpToTreeTablePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'treeTable'
	],
	#category : #'Spec-Toplo-Examples-Tree'
}

{ #category : #layout }
SpToTreeTablePresenter class >> openInToplo [

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
SpToTreeTablePresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #treeTable;
		  yourself
]

{ #category : #initialization }
SpToTreeTablePresenter >> initializePresenters [

	treeTable := self newTreeTable
		             addStyle: 'stTree';
		             addColumn:
			             (SpStringTableColumn
				              title: 'Class hierarchy'
				              evaluated: #name);
		             roots: { SpPresenter };
		             children: [ :aClass | aClass subclasses ];
		             yourself
]
