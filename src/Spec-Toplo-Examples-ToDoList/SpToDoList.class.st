Class {
	#name : #SpToDoList,
	#superclass : #Object,
	#instVars : [
		'tasks',
		'announcer'
	],
	#category : #'Spec-Toplo-Examples-ToDoList-Model'
}

{ #category : #examples }
SpToDoList class >> exampleWithSomeTasks [

	^ self new
		  addNewTaskTitled: 'Create example' described: 'It should show most current features:
* Label
* List
* Button';
		  addNewTaskTitled: 'Commit it' described: 'Place a good comment, of course.';
		  addNewTaskTitled: 'Push to repository' described: 'This is obvious but...';
		  in: [ :list | list tasks first priority: SpToDoTaskPriority high ];
		  yourself
]

{ #category : #accessing }
SpToDoList >> addNewTaskTitled: aString described: anotherString [

	| newTask |
	newTask := SpToDoTask titled: aString described: anotherString in: self.
	newTask validate.

	tasks add: newTask.
	self announceUpdated.

	^ newTask	
]

{ #category : #announcements }
SpToDoList >> announceUpdated [

	announcer announce: SpToDoListUpdated
]

{ #category : #announcements }
SpToDoList >> announcer [

	^ announcer
]

{ #category : #accessing }
SpToDoList >> delete: aToDoTask [

	tasks remove: aToDoTask.
	self announceUpdated
]

{ #category : #accessing }
SpToDoList >> deleteAll [

	tasks removeAll.
	self announceUpdated
]

{ #category : #initialization }
SpToDoList >> initialize [

	super initialize.
	tasks := OrderedCollection new.
	announcer := Announcer new
]

{ #category : #accessing }
SpToDoList >> tasks [

	^ tasks
]

{ #category : #announcements }
SpToDoList >> whenUpdatedSend: aSelector to: aSubscriber [

	announcer weak
		when: SpToDoListUpdated
		send: aSelector
		to: aSubscriber
]
