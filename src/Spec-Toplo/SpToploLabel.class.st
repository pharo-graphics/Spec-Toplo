"
I'm a Toplo label that adds some particulatiries that Spec needs.

This is the case of enabled.

"
Class {
	#name : #SpToploLabel,
	#superclass : #ToLabel,
	#traits : 'TToEnableable',
	#classTraits : 'TToEnableable classTrait',
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #initialization }
SpToploLabel >> initialize [

	super initialize.

	self
		addDresser: SpToploEnableableLabelDresser new;
		matchParent.

	"Workaround. See: https://github.com/plantec/Toplo/issues/29"
	self whenTextReplacedDo: [ :new :old |
		new
			when: BlTextStringsInserted send: #textChanged to: self;
			when: BlTextsDeleted send: #textChanged to: self;
			when: BlTextAttributeAdded send: #textChanged to: self;
			when: BlTextAttributesRemoved send: #textChanged to: self.
		old unsubscribe: self ]
]
