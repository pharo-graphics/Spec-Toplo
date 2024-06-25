Class {
	#name : #SpToploBackendForTest,
	#superclass : #SpAbstractBackendForTest,
	#classTraits : 'TAssertable classTrait',
	#instVars : [
		'app'
	],
	#category : #'Spec-Toplo-Tests'
}

{ #category : #asserting }
SpToploBackendForTest >> assertIcon: aForm equals: anotherForm [

	self assert: anotherForm = aForm
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

{ #category : #testing }
SpToploBackendForTest >> waitUntilUIRedrawed [
	"Wait BlSpace is opened and doesn't have available tasks to execute. 
	This is important since the SpToplo* adapters are usually not synchronous: they defer tasks.
	
	Inspired on BlDevScripterWaitStep>>#forEmptySpaceTaskQueueTimeout:"

	| aSpace |
	aSpace := app windows anyOne adapter widget.
	BlSpace
		pulseUntilSpaceOpenedAndEmptyTaskQueue: aSpace
		timeout: 500 milliSeconds
]
