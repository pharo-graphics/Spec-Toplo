Trait {
	#name : #SpToploTWithContextMenu,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #'updating widget' }
SpToploTWithContextMenu >> fillContextMenu: aContextMenu [

	| aMenuPresenter aMenuWidget |

	aMenuPresenter := self presenter contextMenu
		ifNotNil: [ :aValuable | aValuable value ]
		ifNil: [ ^ self ].

	aMenuWidget := aMenuPresenter
		owner: self presenter;
		build.

	aContextMenu addAllItems: aMenuWidget items
]

{ #category : #'updating widget' }
SpToploTWithContextMenu >> updateMenu [
	"Some presenters with context menu send this message to their adapters."

	self widget contextMenu: [ :aContextMenu :request |
		self fillContextMenu: aContextMenu ]
]
