"
I represent a window to add a `SpToDoTask` to a `SpToDoList`.
"
Class {
	#name : #SpToDoTaskDialog,
	#superclass : #SpDialogPresenter,
	#instVars : [
		'task',
		'titleLabel',
		'titleInput',
		'descriptionLabel',
		'descriptionTextArea',
		'toDoList',
		'priorityLabel',
		'priorityDropList'
	],
	#category : #'Spec-Toplo-Examples-ToDoList-Presenters'
}

{ #category : #layout }
SpToDoTaskDialog class >> defaultLayout [

	^ SpBoxLayout newVertical
		  borderWidth: 5;
		  spacing: 5;
		  add: #titleLabel expand: false;
		  add: #titleInput expand: false;
		  add: (SpBoxLayout newHorizontal
				add: #priorityLabel expand: false;
				add: #priorityDropList;
				yourself)
				expand: false;
		  add: #descriptionLabel expand: false;
		  add: #descriptionTextArea;
		  yourself

]

{ #category : #private }
SpToDoTaskDialog >> accept [

	[ 	| newTask |
		newTask := toDoList addNewTaskTitled: titleInput text described: descriptionTextArea text.
		newTask priority: priorityDropList selectedItem.
		titleInput text: ''.
		super accept.
	]	on: SpToDoListValidationError
		do: [ :error | self showError: error ]
]

{ #category : #initialization }
SpToDoTaskDialog >> initializeDialogWindow: aDialogWindowPresenter [

	super initializeDialogWindow: aDialogWindowPresenter.

	aDialogWindowPresenter
		initialExtent: 300 @ 250;
		title: 'Create a new task';
		addDefaultButton: 'Add to List' do: [ :presenter | self accept ];
		addButton: 'Cancel' do: [ :presenter | self cancel ]
]

{ #category : #initialization }
SpToDoTaskDialog >> initializePresenter [

	super initializePresenter.

	titleLabel := self newLabel
		              label: 'Title:';
		              yourself.

	titleInput := self newTextInput.

	priorityLabel := self newLabel
		                 label: 'Priority:';
		                 yourself.

	priorityDropList := self newDropList
		                    display: [ :item | 
			                    item
				                    ifNil: [ '-- none ---' ]
				                    ifNotNil: [ item name ] ];
		                    displayIcon: [ :item | self priorityFormFor: item rank ];
		                    items: SpToDoTaskPriority allPredefined;
		                    selectIndex: 1;
		                    yourself.

	descriptionLabel := self newLabel
		                    label: 'Description:';
		                    yourself.

	descriptionTextArea := self newText
]

{ #category : #private }
SpToDoTaskDialog >> priorityFormFor: ratio [

	| width height ratioBottomColor ratioTopColor |
	width := 16.
	height := 16.
	ratioBottomColor := Color veryLightGray.
	ratioTopColor := Color red.

	^ (FormCanvas extent: width @ height)
		fillColor: ratioBottomColor;
		drawRectangle: (0 asPoint extent: (ratio * (width-1)) ceiling @ (height-1))
			color: ratioTopColor
			borderWidth: 1
			borderColor: ratioBottomColor;
		form
]

{ #category : #initialization }
SpToDoTaskDialog >> setModelBeforeInitialization: aSpToDoList [

	toDoList := aSpToDoList
]

{ #category : #actions }
SpToDoTaskDialog >> showError: error [

	self application newInform
		title: 'Validation Error';
		label: error messageText;
		parentWindow: self window;
		openDialog
]
