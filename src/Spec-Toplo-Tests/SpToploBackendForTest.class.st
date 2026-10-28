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
	"Close every window opened by the test and wait (at most 2 seconds) for the headless host to process the closes."

	app ifNil: [ ^ self ].
	app windows copy do: [ :each | each isWindowPresenter ifTrue: [ each close ] ].
	self waitHeadlessHostUntil: [ BlHeadlessHost default isSettled ]
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

{ #category : #running }
SpToploBackendForTest >> waitHeadlessHostUntil: aConditionBlock [
	"Wait (at most 2 seconds) for the headless host to pulse until aConditionBlock evaluates to true.
	While the condition is not satisfied, a pulse is requested again on each check: the test environment terminates processes forked during a test, so the pulse loop started by a close sent from #tearDown (`window delete`) is killed before running and leaves that close queued with no loop running. #requestPulse restarts the loop when it is not running and only wakes it up otherwise."

	| host deadline |
	host := BlHeadlessHost default.
	deadline := DateAndTime now + 2 seconds.
	host
		waitUntil: [
				aConditionBlock value ifFalse: [ host requestPulse ].
				aConditionBlock value ]
		timeOutIf: [ DateAndTime now > deadline ]
		onCompletion: [ ]
		onTimeout: [ ]
]

{ #category : #testing }
SpToploBackendForTest >> waitUntilUIRedrawed [
	"Wait (at most 2 seconds) until the headless host and the space of every open window are settled.
	This is important since the SpToplo* adapters are usually not synchronous: they defer tasks."

	| host spaces |
	host := BlHeadlessHost default.
	spaces := (app windows select: [ :each | each isWindowPresenter ])
		          collect: [ :each | each adapter widget ]
		          thenSelect: [ :each | each isKindOf: BlSpace ].
	spaces ifEmpty: [ ^ self ].
	self waitHeadlessHostUntil: [ host isSettled and: [ spaces allSatisfy: [ :each | host isSpaceSettled: each ] ] ]
]
