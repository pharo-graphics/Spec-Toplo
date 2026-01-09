Class {
	#name : #SpToploToolbarPopoverButtonAdapter,
	#superclass : #SpToploToolbarButtonAdapter,
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #initialization }
SpToploToolbarPopoverButtonAdapter >> updateAction [

	widget clickAction: [
			self presenter newPopover
				addStyle: 'popoverButton';
				presenter: self presenter content value;
				popup ]
]
