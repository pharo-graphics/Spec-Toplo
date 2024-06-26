"
I'm a Spec2 presenter to manage a ToDo list.

The goal is to be an example of use of Spec with Toplo as backend, but it should work with other backends, too.

To open with Toplo, evaluate:
```
| app model presenter |
app := SpApplication new 
  useBackend: #Toplo;
  yourself.

model := SpToDoList exampleWithSomeTasks.
presenter := SpToDoListPresenter newApplication: app model: model.
presenter open.
```
"
Class {
	#name : #SpToDoListPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'listLabel',
		'list',
		'deleteButton',
		'toDoList',
		'toggleCompletedButton',
		'toolbar',
		'statusBar',
		'descriptionLabel',
		'descriptionTextArea'
	],
	#category : #'Spec-Toplo-Examples-ToDoList-Presenters'
}

{ #category : #layout }
SpToDoListPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  borderWidth: 5;
		  spacing: 5;
		  add: (SpPanedLayout newLeftToRight
				   positionOfSlider: 60 percent;
				   add: (SpBoxLayout newTopToBottom
						    add: #listLabel expand: false;
						    add: #list;
						    add: (SpBoxLayout newLeftToRight
								     add: #toggleCompletedButton;
								     add: #deleteButton;
								     yourself)
						    expand: false;
						    yourself);
				   add: (SpBoxLayout newTopToBottom
						    add: #descriptionLabel expand: false;
						    add: #descriptionTextArea;
						    yourself);
				   yourself)
]

{ #category : #actions }
SpToDoListPresenter >> completeAllTasks [

	toDoList tasks do: [ :each | each completed: true ]
]

{ #category : #initialization }
SpToDoListPresenter >> connectPresenters [

	super connectPresenters.
	
	list whenSelectionChangedDo: [ :aSelection |
		self refreshAccordingToSelectedTask ]
]

{ #category : #initialization }
SpToDoListPresenter >> contextMenuForSelectedTask [

	| aTask menu |
	aTask := list selectedItem.

	menu := self newMenu.

	menu addGroup: [ :aGroup | 
		aGroup
			addItem: [ :item | 
				item
					name: 'Toggle done';
					iconName: #smallOk;
					action: [ self toggleCompletedTask ] ];
			addItem: [ :item | 
				item
					name: 'Delete';
					iconName: #remove;
					action: [ self deleteTask ] ] ].

	^ menu
]

{ #category : #actions }
SpToDoListPresenter >> deleteAllTasks [

	toDoList deleteAll
]

{ #category : #actions }
SpToDoListPresenter >> deleteTask [
	
	toDoList delete: list selectedItem
]

{ #category : #initialization }
SpToDoListPresenter >> initializePresenters [

	listLabel := self newLabel
		label: 'Tasks:';
		yourself.
	
	list := self newList
		displayIcon: [ :aToDoTask | self taskIconFor: aToDoTask ];
		display: [ :aToDoTask | self taskDisplayFor: aToDoTask ];
		whenActivatedDo: [ self toggleCompletedTask ];
		contextMenu: [ self contextMenuForSelectedTask ];
		yourself.

	descriptionLabel := self newLabel
		label: 'Description:';
		yourself.

	descriptionTextArea := self newText
		disable;
		yourself.
	
	toggleCompletedButton := self newButton
		label: 'Toggle done';
		icon: (self iconNamed: #smallOk);
		action: [ self toggleCompletedTask ];
		yourself.

	deleteButton := self newButton
		label: 'Delete';
		icon: (self iconNamed: #remove);
		action: [ self deleteTask ];
		yourself.

	self initializeToolbar.
	statusBar := self newLabel.

	self refresh.
]

{ #category : #initialization }
SpToDoListPresenter >> initializeToolbar [
	
	toolbar := self newToolbar.

	toolbar addItem: (self newToolbarButton
		icon: (self iconNamed: #smallAdd);
		label: 'Create';
		action: [ self openAddTaskDialog ];
		yourself).
	
	toolbar addItemRight: (self newToolbarButton
		icon: (self iconNamed: #smallOk);
		label: 'All done';
		action: [ self completeAllTasks ];
		yourself).
		
	toolbar addItemRight: (self newToolbarButton
		icon: (self iconNamed: #remove);
		label: 'Clean';
		action: [ self deleteAllTasks ];
		yourself).
]

{ #category : #initialization }
SpToDoListPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Demo @ ' , aWindowPresenter application backend asString;
		initialExtent: 600 @ 300;
		centered;
		statusBar: statusBar;
		toolbar: toolbar.
]

{ #category : #actions }
SpToDoListPresenter >> openAddTaskDialog [

	(SpToDoTaskDialog newApplication: self application model: toDoList)
		parentWindow: self window;
		openDialog
]

{ #category : #private }
SpToDoListPresenter >> presentersThatRequireTaskSelected [

	^ { deleteButton. toggleCompletedButton }
]

{ #category : #private }
SpToDoListPresenter >> refresh [ 

	list unselectAll.
	list items: toDoList tasks.
	statusBar label: ('Number of tasks: {1}' format: { toDoList tasks size}).
	self refreshAccordingToSelectedTask.
]

{ #category : #private }
SpToDoListPresenter >> refreshAccordingToSelectedTask [

	| hasSelection |
	hasSelection := list selection isEmpty not.

	self refreshDescriptionTextArea.

	self presentersThatRequireTaskSelected do: [ :each | 
		each enabled: hasSelection ]
]

{ #category : #private }
SpToDoListPresenter >> refreshDescriptionTextArea [

	| newDescription |
	newDescription := list selectedItem
		                  ifNil: [ '' ]
		                  ifNotNil: [ :selectedTask | 
				                  selectedTask description ].

	descriptionTextArea text: newDescription
]

{ #category : #initialization }
SpToDoListPresenter >> setModelBeforeInitialization: aSpToDoList [

	toDoList := aSpToDoList.
	toDoList whenUpdatedSend: #refresh to: self
]

{ #category : #private }
SpToDoListPresenter >> taskDisplayFor: aToDoTask [

	^ '{1} ({2} priority)' format: { 
			  aToDoTask title.
			  aToDoTask priority name }
]

{ #category : #private }
SpToDoListPresenter >> taskIconFor: aToDoTask [ 
	
	| aForm |
	aForm := self iconNamed: #smallOk.

	aToDoTask isCompleted
		ifFalse: [ aForm := aForm dimmed: 0.2 ].
	
	^ aForm
]

{ #category : #actions }
SpToDoListPresenter >> toggleCompletedTask [
	
	| selectedTask |
	selectedTask := list selectedItem.
	selectedTask completed: selectedTask isCompleted not
]
