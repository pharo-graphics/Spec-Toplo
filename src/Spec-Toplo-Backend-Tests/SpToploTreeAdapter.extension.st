Extension { #name : #SpToploTreeAdapter }

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploTreeAdapter >> sendClickEventToRowAtPath: aCollection [

	| position listItemElement |
	position := (widget dataSource itemsAtPath: aCollection) anyOne position.
	listItemElement := widget nodes at: position.
	BlSpace simulateClickOn: listItemElement.
	BlSpace pulseUntilEmptyTaskQueue: listItemElement space timeout: 200 milliSeconds
]

{ #category : #'*Spec-Toplo-Backend-Tests' }
SpToploTreeAdapter >> sendClickWithShiftEventToRowAtPath: aCollection [

	| position listItemElement aPosition |
	position := (widget dataSource itemsAtPath: aCollection) anyOne position.
	listItemElement := widget nodes at: position.
	"we never know if an element was already layered out"
	listItemElement topMostParent forceLayout.
	aPosition := listItemElement bounds inSpace center.


	BlSpace
		simulateEvents: {
				((BlMouseDownEvent button: BlMouseButton primary)
					 position: aPosition;
					 modifiers: (BlKeyModifiers
							  shift: true
							  ctrl: false
							  alt: false
							  cmd: false);
					 yourself).
				((BlMouseUpEvent button: BlMouseButton primary)
					 position: aPosition;
					 modifiers: (BlKeyModifiers
							  shift: true
							  ctrl: false
							  alt: false
							  cmd: false);
					 yourself) }
		on: listItemElement.
	BlSpace pulseUntilEmptyTaskQueue: listItemElement space timeout: 200 milliSeconds
]
