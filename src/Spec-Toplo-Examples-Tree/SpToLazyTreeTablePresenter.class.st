"
I show a tree table whose children are computed lazily (#lazilyComputeChildren) on the Toplo backend.

Roots are a few classes; the children of a class are its subclasses. A node's children are only computed when it is expanded, and the label at the bottom counts how many times that happened.

What to look at:
- every node shows an expand arrow before it is expanded, even classes without subclasses (their children have not been computed yet);
- expanding a node increases the counter;
- expanding a class without subclasses makes its arrow disappear.

	SpToLazyTreeTablePresenter openInToplo
"
Class {
	#name : #SpToLazyTreeTablePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'treeTable',
		'computationsLabel',
		'computations'
	],
	#category : #'Spec-Toplo-Examples-Tree'
}

{ #category : #layout }
SpToLazyTreeTablePresenter class >> openInToplo [

	<script>
	| app presenter |
	app := SpApplication new
		       useBackend: #Toplo;
		       yourself.
	presenter := self newApplication: app.
	presenter open.
	^ presenter
]

{ #category : #private }
SpToLazyTreeTablePresenter >> computeChildrenOf: aClass [

	computations := computations + 1.
	self updateComputationsLabel.
	^ aClass subclasses sorted: [ :a :b | a name < b name ]
]

{ #category : #layout }
SpToLazyTreeTablePresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #treeTable;
		  add: #computationsLabel expand: false;
		  yourself
]

{ #category : #initialization }
SpToLazyTreeTablePresenter >> initializePresenters [
	"Children (subclasses) are only computed when a node is expanded.
	The label counts these computations to make the laziness visible."

	computations := 0.
	computationsLabel := self newLabel.
	self updateComputationsLabel.
	treeTable := self newTreeTable
		             addStyle: 'stTree';
		             addColumn: (SpStringTableColumn title: 'Class' evaluated: #name);
		             addColumn: (SpStringTableColumn title: 'Package' evaluated: [ :aClass | aClass package name ]);
		             roots: {
				             SpAbstractPresenter.
				             SpTableColumn };
		             children: [ :aClass | self computeChildrenOf: aClass ];
		             lazilyComputeChildren;
		             yourself
]

{ #category : #private }
SpToLazyTreeTablePresenter >> updateComputationsLabel [

	computationsLabel label: 'Children computed ' , computations printString , ' time(s)'
]
