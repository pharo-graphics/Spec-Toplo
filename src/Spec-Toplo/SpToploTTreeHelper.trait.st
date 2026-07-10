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

	self model selection isMultipleSelection
		ifTrue: [ self treeWidget selecter selectIndex: index ]
		ifFalse: [ self treeWidget selecter selectOnlyIndex: index ]
]

{ #category : #accessing }
SpToploTTreeHelper >> selectedPaths [

	^ self treeWidget selecter selectedIndexes collect: [ :each |
		  (self treeWidget dataSource pathOfIndex: each) asArray ]
]

{ #category : #initialization }
SpToploTTreeHelper >> suspendUpdateSelectionDuring: aBlock [

	suspendUpdateSelection := true.
	aBlock ensure: [ suspendUpdateSelection := false ]
]

{ #category : #initialization }
SpToploTTreeHelper >> transferSelectionChange: evt [

	| currentPaths selectedIndex |
	self suspendUpdateSelectionDuring: [
			evt selectedIndexes ifEmpty: [ "UI is not ready?" ^ self ].
			selectedIndex := evt selectedIndexes first.

			selectedIndex > evt currentTarget dataSource size ifTrue: [
				^ self flag: #'might be a bug' ].
			currentPaths := (evt currentTarget dataSource pathOfIndex:
				                 selectedIndex) asArray.
			currentPaths = self model selection selectedPaths ifTrue: [ ^ self ].

			self model selection selectPaths: { currentPaths } ]
]

{ #category : #initialization }
SpToploTTreeHelper >> treeWidget [

	^ self shouldBeImplemented
]
