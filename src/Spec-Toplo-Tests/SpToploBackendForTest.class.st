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

{ #category : #running }
SpToploBackendForTest >> closeAllWindows [
	"Close every window opened by the test and wait (at most 2 seconds) for the headless host to process the closes.
	While the host is not settled, a pulse is requested again on each check: the test environment terminates processes forked during a test, so the pulse loop started by a close sent from #tearDown (`window delete`) is killed before running and leaves that close queued with no loop running. #requestPulse restarts the loop when it is not running and only wakes it up otherwise."

	| host deadline |
	app ifNil: [ ^ self ].
	app windows copy do: [ :each | each isWindowPresenter ifTrue: [ each close ] ].
	host := BlHeadlessHost default.
	deadline := DateAndTime now + 2 seconds.
	host
		waitUntil: [
				host isSettled ifFalse: [ host requestPulse ].
				host isSettled ]
		timeOutIf: [ DateAndTime now > deadline ]
		onCompletion: [ ]
		onTimeout: [ ]
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

	| previousPreferredHost |
	previousPreferredHost := BlHostRegistry default preferredHost.
	BlHostRegistry default preferredHost: BlHeadlessHost default.
	[
		app := SpApplication new.
		app useBackend: #Toplo.
		app propertyAt: #testBackend put: self.
		aBlock value ] ensure: [ [ self closeAllWindows ] ensure: [ BlHostRegistry default preferredHost: previousPreferredHost ] ]
]

{ #category : #testing }
SpToploBackendForTest >> waitUntilUIRedrawed [
	"Wait BlSpace is opened and doesn't have available tasks to execute. 
	This is important since the SpToplo* adapters are usually not synchronous: they defer tasks.
	
	Inspired on BlDevScripterWaitStep>>#forEmptySpaceTaskQueueTimeout:"

	| aSpace |
	app windows ifNotEmpty: [
			aSpace := app windows anyOne adapter widget.
			aSpace settleForDuration: 200 milliSeconds ]
]
