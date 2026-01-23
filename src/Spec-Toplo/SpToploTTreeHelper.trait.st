Trait {
	#name : #SpToploTTreeHelper,
	#instVars : [
		'suspendUpdateSelection'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'expanding-collapsing' }
SpToploTTreeHelper >> expandRoots [

	self treeWidget expandRoots
]

{ #category : #initialization }
SpToploTTreeHelper >> selectPath: aPath [

	| items index |
	aPath ifEmpty: [ ^ self treeWidget selecter deselectAll ].

	items := self treeWidget dataSource itemsAtPath: aPath.
	index := items last position.

	self widget selecter
		deselectAll;
		selectIndex: index
]

{ #category : #accessing }
SpToploTTreeHelper >> selectedPaths [

	^ self treeWidget selectionModel selectedIndexes collect: [ :each |
		  self treeWidget dataSource pathOfIndex: each ]
]

{ #category : #initialization }
SpToploTTreeHelper >> suspendUpdateSelectionDuring: aBlock [

	suspendUpdateSelection := true.
	aBlock ensure: [ suspendUpdateSelection := false ]
]

{ #category : #initialization }
SpToploTTreeHelper >> transferSelectionChange: evt [

	| currentPaths |
	self suspendUpdateSelectionDuring: [
		currentPaths := self selectedPaths.

		currentPaths = self model selection selectedPaths ifTrue: [ ^ self ].

		self model selection
			clearSelection;
			selectPaths: currentPaths ]
]

{ #category : #initialization }
SpToploTTreeHelper >> treeWidget [

	^ self shouldBeImplemented
]
