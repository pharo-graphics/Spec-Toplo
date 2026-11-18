"
I'm a Spec adapter for `SpToolbarPopoverButtonPresenter`.
"
Class {
	#name : #SpToploToolbarPopoverButtonAdapter,
	#superclass : #SpToploToolbarButtonAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #initialization }
SpToploToolbarPopoverButtonAdapter >> updateAction [

	widget clickAction: [
			model newPopover
				addStyle: 'popoverButton';
				presenter: model content value;
				popup ]
]
