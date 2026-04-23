Class {
	#name : #SpToploToolbarAdapterTest,
	#superclass : #TestCase,
	#instVars : [
		'application'
	],
	#category : #'Spec-Toplo-Tests-Adapters'
}

{ #category : #running }
SpToploToolbarAdapterTest >> setUp [

	super setUp.
	application := SpApplication new.
	application useBackend: #Toplo
]

{ #category : #running }
SpToploToolbarAdapterTest >> tearDown [

	application ifNotNil: [ application windows do: [ :each | each delete ] ].
	super tearDown
]

{ #category : #tests }
SpToploToolbarAdapterTest >> testBuildWithToImageIconKeepsSourceIconDetached [

	| presenter button sourceIcon widget builtItem |
	presenter := SpToolbarPresenter new
		             application: application;
		             yourself.
	button := SpToolbarButtonPresenter new
		          application: application;
		          yourself.
	sourceIcon := ToMaterialDesignIconProvider new iconNamed: #outlined_menu ifAbsent: [ self fail ].
	button icon: sourceIcon.
	presenter add: button.

	widget := presenter build.
	builtItem := widget items first.

	self assert: builtItem class equals: ToMenuItem.
	self assert: sourceIcon parent isNil.
	self deny: builtItem startElement == sourceIcon.
	self assert: builtItem startElement sourceImage equals: sourceIcon sourceImage
]
