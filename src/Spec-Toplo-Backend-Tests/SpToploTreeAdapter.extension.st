Extension { #name : #SpToploTreeAdapter }

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploTreeAdapter >> sendClickEventToRowAtPath: aCollection [

	| position listItemElement |
	position := (widget dataSource itemsAtPath: aCollection) anyOne position.
	listItemElement := widget nodes at: position.
	BlSpace simulateClickOn: listItemElement.
	BlSpace pulseUntilEmptyTaskQueue: listItemElement space timeout: 200 milliSeconds
]
