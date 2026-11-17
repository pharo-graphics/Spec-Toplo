Trait {
	#name : #SpToploTWithContextMenu,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'updating widget' }
SpToploTWithContextMenu >> fillContextMenu: aContextMenu [

	| aMenuPresenter aMenuWidget |
	aMenuPresenter := self menuPresenterIfAbsent: [ ^ self ].

	aMenuWidget := aMenuPresenter owner: self presenter; build.

	aContextMenu addAllItems: aMenuWidget items
]

{ #category : #'updating widget' }
SpToploTWithContextMenu >> menuPresenterIfAbsent: aBlock [

	| aMenuPresenter |
	self presenter actions ifNotNil: [ :actions |
		aMenuPresenter := self presenter newMenu.
		aMenuPresenter fillWith: actions ].
	self presenter contextMenu ifNotNil: [ :aContextMenuValuable |
		self presenter actions ifNotNil: [
			Error signal: 'You are using contextMenu: and actions: at the same time. Both mechanisms are mutually exclusive.' ].
		aMenuPresenter := aContextMenuValuable value ].

	^ aMenuPresenter ifNil: [ aBlock value ]
]

{ #category : #'updating widget' }
SpToploTWithContextMenu >> updateMenu [
	"Some presenters with context menu send this message to their adapters."

	self widget contextMenuBuilder: [ :aContextMenu :request |
		self fillContextMenu: aContextMenu ]
]
