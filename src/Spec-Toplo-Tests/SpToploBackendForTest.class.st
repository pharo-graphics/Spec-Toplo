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
SpToploBackendForTest >> assertHasHeader: anAdapter [ 
	self waitUntilUIRedrawed.
	
	self assert: (anAdapter widget instVarNamed: #showHeader)
]

{ #category : #asserting }
SpToploBackendForTest >> assertIcon: aForm equals: anotherForm [

	self assert: anotherForm = aForm
]

{ #category : #asserting }
SpToploBackendForTest >> assertImage: actual equals: expected [

	(expected isNil and: [ actual isNil or: [
			actual width = 1 and: [ actual height = 1 ] ] ])
		ifTrue: [ ^ self ].

	self assert: actual width = expected width.
	self assert: actual height = expected height.
	self assert: actual bits = expected bits
]

{ #category : #asserting }
SpToploBackendForTest >> assertList: anAdapter displayItems: aCollection [ 
	| tableContainer tableRowContents |
	
	self waitUntilUIRedrawed.
	
	tableContainer := anAdapter widget list innerElement.
	tableRowContents := tableContainer children collect: [ :row | 
		| cell |
		cell := (row node childWithId: #Value) cell.
		cell children anyOne text asString ].
	
	self assert: tableRowContents first = aCollection first.
	self assert: tableRowContents second = aCollection second.
	self assert: tableRowContents third = aCollection third.
]

{ #category : #simulating }
SpToploBackendForTest >> doubleClickFirstRowAndColumn: aSpToploListAdapter [
	 
	BlSpace simulateDoubleClickOn: aSpToploListAdapter widget nodes first
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
	app propertyAt: #testBackend put: self.
	aBlock value
]

{ #category : #testing }
SpToploBackendForTest >> waitUntilUIRedrawed [
	"Wait BlSpace is opened and doesn't have available tasks to execute. 
	This is important since the SpToplo* adapters are usually not synchronous: they defer tasks.
	
	Inspired on BlDevScripterWaitStep>>#forEmptySpaceTaskQueueTimeout:"

	| aSpace |
	app windows ifNotEmpty: [
			aSpace := app windows anyOne adapter widget.
			BlSpace
				pulseUntilSpaceOpenedAndEmptyTaskQueue: aSpace
				timeout: 200 milliSeconds ]
]
