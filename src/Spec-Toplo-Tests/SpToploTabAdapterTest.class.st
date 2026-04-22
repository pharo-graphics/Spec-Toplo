Class {
	#name : #SpToploTabAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #helpers }
SpToploTabAdapterTest >> newTabPresenterWithInitialPageIndex: anInteger [

	| presenter instanceLabel classLabel traitLabel |
	presenter := application instantiate: SpPresenter.
	instanceLabel := presenter newLabel
		                 label: 'Instance body';
		                 yourself.
	classLabel := presenter newLabel
		              label: 'Class body';
		              yourself.
	traitLabel := presenter newLabel
		              label: 'Traits body';
		              yourself.
	presenter layout: (SpTabLayout new
			 add: instanceLabel label: 'Instance';
			 add: classLabel label: 'Class';
			 add: traitLabel label: 'Traits';
			 initialPageIndex: anInteger;
			 yourself).
	^ presenter
]

{ #category : #running }
SpToploTabAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #running }
SpToploTabAdapterTest >> tearDown [

	application ifNotNil: [ application windows do: [ :each | each delete ] ].
	super tearDown
]

{ #category : #tests }
SpToploTabAdapterTest >> testBuildAddsEachTabOnce [

	| presenter widget |
	presenter := self newTabPresenterWithInitialPageIndex: 1.
	widget := presenter build.

	self assert: widget items size equals: 3
]

{ #category : #tests }
SpToploTabAdapterTest >> testBuildSelectsInitialPage [

	| presenter widget |
	presenter := self newTabPresenterWithInitialPageIndex: 2.
	widget := presenter build.

	self assert: widget selecter selectedIndexes equals: #( 2 )
]
