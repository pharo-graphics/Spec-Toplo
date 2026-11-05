Class {
	#name : #SpToploBackendForTest,
	#superclass : #SpAbstractBackendForTest,
	#instVars : [
		'app',
		'host',
		'initialSpaces'
	],
	#category : #'Spec-Toplo-Tests-Backend'
}

{ #category : #accessing }
SpToploBackendForTest class >> availableBackendsForTest [

	^ BlParameterizedHostTest availableHosts collect: [ :each | self host: each ]
]

{ #category : #'instance creation' }
SpToploBackendForTest class >> host: aHost [

	^ self new
		host: aHost;
		yourself
]

{ #category : #asserting }
SpToploBackendForTest >> assertHasHeader: anAdapter [

	self waitUntilUIRedrawed.
	self assert: anAdapter hasHeader
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

	| displayedStrings |
	self waitUntilUIRedrawed.

	displayedStrings := (self listElementOf: anAdapter) nodes collect: [ :each | self displayedStringOf: each ].

	self assert: (displayedStrings first: aCollection size) asArray = aCollection asArray
]

{ #category : #simulating }
SpToploBackendForTest >> clickFirstRowAndColumn: aSpToploListAdapter [

	self waitUntilUIRedrawed.
	(self firstRowNodeOf: aSpToploListAdapter) eventSimulator click
]

{ #category : #running }
SpToploBackendForTest >> closeAllWindows [
	"Close every window opened by the test, ensure any newly opened space is closed, and wait for the host to settle."

	[ app windows copy do: [ :each | each close ] ] ensure: [
		self host spaces
			reject: [ :each | initialSpaces includes: each ]
			thenDo: [ :each | each close ].
		self host isRunning ifTrue: [ self host settle ] ]
]

{ #category : #private }
SpToploBackendForTest >> displayedStringOf: aNode [
	"Answer the text of the first label found breadth-first in aNode, or nil."

	^ aNode
		  allChildrenBreadthFirstDetect: [ :each | each isKindOf: ToLabel ]
		  ifFound: [ :label | label text asString ]
		  ifNone: [ nil ]
]

{ #category : #simulating }
SpToploBackendForTest >> doubleClickFirstRowAndColumn: aSpToploListAdapter [

	self waitUntilUIRedrawed.
	(self firstRowNodeOf: aSpToploListAdapter) eventSimulator doubleClick
]

{ #category : #simulating }
SpToploBackendForTest >> firstRowNodeOf: aSpToploListAdapter [
	"Answer the node of the first row of the adapted list or table."

	^ (self listElementOf: aSpToploListAdapter) nodes first
]

{ #category : #private }
SpToploBackendForTest >> listElementOf: anAdapter [
	"A ToTableElement holds its rows in its inner list element."

	^ aSpToploListAdapter firstRowNode
]

{ #category : #accessing }
SpToploBackendForTest >> host [

	^ host ifNil: [ host := BlHeadlessHost default ]
]

{ #category : #accessing }
SpToploBackendForTest >> host: aHost [

	host := aHost
]

{ #category : #opening }
SpToploBackendForTest >> openInstanceOf: aTest [

	aTest window ifNil: [ 
		aTest presenter application: app.
		aTest window: aTest presenter open ].

	self waitUntilUIRedrawed
]

{ #category : #printing }
SpToploBackendForTest >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self host label;
		nextPut: $)
]

{ #category : #running }
SpToploBackendForTest >> runBelowPulseLoopPriority: aBlock [
	"Spec2 generic tests (such as SpAbstractAdapterTest subclasses) do not call settle or waitUntilUIRedrawed between mutations and assertions.
	Run the test just below the pulse loop priority so that the pulse loop preempts the test runner immediately whenever a pulse is requested.
	Native Spec-Toplo tests should still rely on #waitUntilUIRedrawed for multi-frame settlement."

	| process previousPriority |
	process := Processor activeProcess.
	previousPriority := process priority.
	process priority: (previousPriority min: self host pulseLoop processPriority - 1).
	^ aBlock ensure: [ process priority: previousPriority ]
]

{ #category : #running }
SpToploBackendForTest >> runTest: aBlock [

	initialSpaces := self host spaces copy.

	self runBelowPulseLoopPriority: [ [
		app := SpApplication new.
		app useBackend: #Toplo.
		app backend host: self host.
		app propertyAt: #testBackend put: self.
		aBlock value
		] ensure: [ self closeAllWindows ] ]
]

{ #category : #testing }
SpToploBackendForTest >> waitUntilUIRedrawed [
	"Wait until the space of every open window is settled."

	app ifNil: [ ^ self ].

	(app windows
		select: [ :each | each hasAdapter ]
		thenCollect: [ :each | each adapter widgetSpace ])
		do: [ :each | each settle ]
]
