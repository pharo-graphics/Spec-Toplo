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

	| widgetPaths modelPaths |
	widgetPaths := self treeWidget selecter selectedIndexes collect: [ :each |
		               (self treeWidget dataSource pathOfIndex: each) asArray ].
	"Toplo keeps the selected indexes sorted: answer them in the order of the presenter selection"
	modelPaths := (self model selection selectedPaths collect: [ :each | each asArray ]) select: [ :each |
		              widgetPaths includes: each ].
	^ modelPaths , (widgetPaths reject: [ :each | modelPaths includes: each ])
]

{ #category : #initialization }
SpToploTTreeHelper >> suspendUpdateSelectionDuring: aBlock [

	suspendUpdateSelection := true.
	aBlock ensure: [ suspendUpdateSelection := false ]
]

{ #category : #initialization }
SpToploTTreeHelper >> transferSelectionChange: evt [

	| currentPaths selectedIndexes currentIndex |
	"Ignore the selection changes made by the adapter itself while updating the widget from the presenter"
	suspendUpdateSelection ifTrue: [ ^ self ].
	self suspendUpdateSelectionDuring: [
			evt selectedIndexes ifEmpty: [ "The user unselect everything"
					self model selection selectPaths: {  }.
					^ self ].
			selectedIndexes := evt selectedIndexes asArray.

			selectedIndexes last > evt currentTarget dataSource size ifTrue: [ ^ self flag: #'might be a bug' ].
			"Toplo keeps the selected indexes sorted. As Morphic fast tables do, put the last selected index first"
			currentIndex := evt currentTarget selecter currentIndex.
			(selectedIndexes includes: currentIndex) ifTrue: [
				selectedIndexes := (selectedIndexes copyWithout: currentIndex) copyWithFirst: currentIndex ].
			currentPaths := selectedIndexes collect: [ :each | (evt currentTarget dataSource pathOfIndex: each) asArray ].
			currentPaths = self model selection selectedPaths ifTrue: [ ^ self ].

			self model selection selectPaths: currentPaths ]
]

{ #category : #initialization }
SpToploTTreeHelper >> treeWidget [

	^ self shouldBeImplemented
]
