"
I show the type-ahead search of lists and tables on the Toplo backend.

Both widgets show the subclasses of Collection. When a widget has the focus, typing letters, digits, '_' or ':' selects the first matching row and a small badge at the bottom right shows the typed text. Backspace removes a character, Escape (or one second without typing) clears it.

What to look at:
- the list on the left uses the default search: a case-insensitive prefix match on the displayed text;
- the table on the right installs a custom matcher with #searchMatching: that matches a substring of the class name.

	SpToTypeAheadSearchPresenter openInToplo
"
Class {
	#name : #SpToTypeAheadSearchPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'helpLabel',
		'list',
		'substringLabel',
		'table'
	],
	#category : #'Spec-Toplo-Examples'
}

{ #category : #layout }
SpToTypeAheadSearchPresenter class >> openInToplo [

	<script>
	| app presenter |
	app := SpApplication new
		       useBackend: #Toplo;
		       yourself.
	presenter := self newApplication: app.
	presenter open.
	^ presenter
]

{ #category : #layout }
SpToTypeAheadSearchPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: #helpLabel expand: false;
		  add: (SpBoxLayout newHorizontal
				   spacing: 10;
				   add: #list;
				   add: (SpBoxLayout newVertical
						    add: #substringLabel expand: false;
						    add: #table;
						    yourself);
				   yourself);
		  yourself
]

{ #category : #initialization }
SpToTypeAheadSearchPresenter >> initializePresenters [

	| classes |
	classes := Collection withAllSubclasses sorted: [ :a :b | a name < b name ].
	helpLabel := self newLabel label: 'Click a list, then type to search. Backspace removes a character, Escape clears.'.
	list := self newList
		        items: classes;
		        display: [ :aClass | aClass name ];
		        yourself.
	substringLabel := self newLabel label: 'Substring search'.
	table := self newTable
		         addColumn: (SpStringTableColumn title: 'Class name' evaluated: #name);
		         addColumn: (SpStringTableColumn title: 'Package name' evaluated: [ :aClass | aClass package name ]);
		         items: classes;
		         searchMatching: [ :aClass :pattern | aClass name asLowercase includesSubstring: pattern asLowercase ];
		         yourself
]
