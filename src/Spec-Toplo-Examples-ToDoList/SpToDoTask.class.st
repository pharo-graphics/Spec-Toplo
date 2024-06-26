Class {
	#name : #SpToDoTask,
	#superclass : #Object,
	#instVars : [
		'title',
		'description',
		'completed',
		'toDoList',
		'priority'
	],
	#category : #'Spec-Toplo-Examples-ToDoList-Model'
}

{ #category : #'instance creation' }
SpToDoTask class >> titled: aString described: anotherString in: aToDoList [

	^ self basicNew
		  initializeTitle: aString described: anotherString in: aToDoList;
		  yourself
]

{ #category : #accessing }
SpToDoTask >> completed: aBoolean [
	
	completed := aBoolean.
	toDoList 	announceUpdated.
]

{ #category : #accessing }
SpToDoTask >> description [

	^ description
]

{ #category : #accessing }
SpToDoTask >> description: aString [

	description := aString.
	toDoList announceUpdated
]

{ #category : #initialization }
SpToDoTask >> initializeTitle: aString described: anotherString in: aSpToDoList [ 

	self initialize.
	toDoList := aSpToDoList.
	title := aString.
	description := anotherString.
	completed := false.
	priority := SpToDoTaskPriority medium.
]

{ #category : #testing }
SpToDoTask >> isCompleted [
	
	^ completed
]

{ #category : #printing }
SpToDoTask >> printOn: aStream [

	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' title: ';
		print: title.
	aStream
		nextPutAll: ' completed: ';
		print: completed
]

{ #category : #accessing }
SpToDoTask >> priority [
	^ priority
]

{ #category : #accessing }
SpToDoTask >> priority: aPriority [

	priority := aPriority.
	toDoList announceUpdated
]

{ #category : #accessing }
SpToDoTask >> title [

	^ title
]

{ #category : #accessing }
SpToDoTask >> title: aString [ 
	
	title := aString.
	toDoList 	announceUpdated.
]

{ #category : #validating }
SpToDoTask >> validate [

	title isEmpty ifTrue: [ 
		SpToDoListValidationError signal: 'Title is empty' ]
]
