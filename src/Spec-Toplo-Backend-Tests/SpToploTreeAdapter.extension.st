Extension { #name : #SpToploTreeAdapter }

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploTreeAdapter >> sendClickEventToRowAtPath: aCollection [

	| position listItemElement |
	position := (widget dataSource itemsAtPath: aCollection) anyOne position.
	listItemElement := widget nodes at: position.
	listItemElement eventSimulator click.
	listItemElement space settleForDuration: 200 milliSeconds
]

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploTreeAdapter >> sendClickWithShiftEventToRowAtPath: aCollection [

	| position listItemElement |
	position := (widget dataSource itemsAtPath: aCollection) anyOne position.
	listItemElement := widget nodes at: position.
	"the event simulator settles the space (and so lays it out) before computing the click position"
	listItemElement eventSimulator
		shiftDown;
		click.
	listItemElement space settleForDuration: 200 milliSeconds
]
