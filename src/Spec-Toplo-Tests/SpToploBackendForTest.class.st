Class {
	#name : #SpToploBackendForTest,
	#superclass : #SpAbstractBackendForTest,
	#traits : 'TAssertable',
	#classTraits : 'TAssertable classTrait',
	#instVars : [
		'app'
	],
	#category : #'Spec-Toplo-Tests'
}

{ #category : #asserting }
SpToploBackendForTest >> assertIcon: anElement equals: aForm [

	self flag: #todo. "We shouldn't know about this accessors"

	self assert: anElement background image equals: aForm
]

{ #category : #opening }
SpToploBackendForTest >> openInstanceOf: aTest [

	aTest window ifNil: [ 
		aTest presenter application: app.
		aTest window: aTest presenter open ].

	self waitUntilUIRedrawed
]

{ #category : #actions }
SpToploBackendForTest >> runTest: aBlock [

	app := SpApplication new.
	app useBackend: #Toplo.
	aBlock value
]

{ #category : #utilities }
SpToploBackendForTest >> waitUntilUIRedrawed [
	"Wait BlSpace doesn't have available tasks to execute. 
	This is important since the SpToplo* adapters are usually not synchronous: they defer tasks.
	
	Inspired on BlDevScripterWaitStep>>#forEmptySpaceTaskQueueTimeout:"

	| deadlineTime space hasTimedOut hasEmptyTaskQueue |
	space := app windows anyOne adapter widget.
	deadlineTime := space time now + 500 milliSeconds.
	space pulse.

	space time
		every: 50 milliSeconds
		while: [
			hasTimedOut := space time now < deadlineTime.
			hasEmptyTaskQueue := space taskQueue isEmpty not.
			hasTimedOut and: [ hasEmptyTaskQueue ] ]
		do: [ 
			#waitUI traceCr.
			space root inUIProcessDo: [ space pulse ].
		].

	^ hasTimedOut
]
