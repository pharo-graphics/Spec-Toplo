Class {
	#name : #SpToploTableAdapter,
	#superclass : #SpToploAbstractListAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploTableAdapter >> buildColumns [

	^ self model columns collect: [ :spCollumn |
			  | column |
			  column := ToTableColumn new
				            title: spCollumn title;
				            key: spCollumn title;
				            "Use yourself by default. It sometimes happen when user give a list of string as data"
				            dataIndex: (spCollumn evaluation ifNil: [ #yourself ]);
				            yourself.
			  spCollumn isSortable ifTrue: [
				  column sorterBlock: spCollumn sortFunction ].
			  column ]
]

{ #category : #factory }
SpToploTableAdapter >> buildWidget [

	| toploColumns table |
	toploColumns := self buildColumns.
	table := ToTableElement new.
	table columns: toploColumns.
	^ table
]
