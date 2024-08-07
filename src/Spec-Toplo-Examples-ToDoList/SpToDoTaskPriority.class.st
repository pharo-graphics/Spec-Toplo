Class {
	#name : #SpToDoTaskPriority,
	#superclass : #Object,
	#instVars : [
		'name',
		'rank'
	],
	#classInstVars : [
		'medium',
		'high',
		'low'
	],
	#category : #'Spec-Toplo-Examples-ToDoList-Model'
}

{ #category : #accessing }
SpToDoTaskPriority class >> allPredefined [

	^ { self low. self high. self medium }
]

{ #category : #accessing }
SpToDoTaskPriority class >> high [

	^ high ifNil: [ high := self newNamed: 'High' rank: 90 percent ]
]

{ #category : #accessing }
SpToDoTaskPriority class >> low [

	^ low ifNil: [ low := self newNamed: 'Low' rank: 10 percent ]
]

{ #category : #accessing }
SpToDoTaskPriority class >> medium [

	^ medium ifNil: [ medium := self newNamed: 'Medium' rank: 50 percent ]
]

{ #category : #'as yet unclassified' }
SpToDoTaskPriority class >> newNamed: aString rank: aNumber [

	^ self basicNew
		  initializeNamed: aString rank: aNumber;
		  yourself
]

{ #category : #initialization }
SpToDoTaskPriority >> initializeNamed: aString rank: aNumber [

	self initialize.

	name := aString.
	rank := aNumber
]

{ #category : #accessing }
SpToDoTaskPriority >> name [

	^ name
]

{ #category : #printing }
SpToDoTaskPriority >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: ' name: ';
		print: name
]

{ #category : #accessing }
SpToDoTaskPriority >> rank [

	^ rank
]
