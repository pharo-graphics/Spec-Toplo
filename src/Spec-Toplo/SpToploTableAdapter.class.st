Class {
	#name : #SpToploTableAdapter,
	#superclass : #SpToploAbstractListAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTableAdapter >> buildColumns [

	^ self model columns collect: [ :spCollumn |
			  ToTableColumn new
				  title: spCollumn title;
				  key: spCollumn title;
				  dataIndex: spCollumn evaluation;
				  yourself ]
]

{ #category : #factory }
SpToploTableAdapter >> buildWidget [

	| toploColumns table |
	toploColumns := self buildColumns.
	table := ToTableElement new.
	table columns: toploColumns.
	^ table
]

{ #category : #'updating widget' }
SpToploTableAdapter >> updateSelection [

	widget list selecter selectIndexes: model selection selectedIndexes
]
