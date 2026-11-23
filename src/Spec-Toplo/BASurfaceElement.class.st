"
I am a dedicated Toplo element for rendering an Athens surface directly onto an Alexandrie canvas (AeCanvas) without converting to a Form.
"
Class {
	#name : #BASurfaceElement,
	#superclass : #ToElement,
	#instVars : [
		'surface'
	],
	#category : #'Spec-Toplo-Widgets'
}

{ #category : #drawing }
BASurfaceElement >> aeDrawGeometryOn: aeCanvas [

	surface ifNil: [
		^ super aeDrawGeometryOn: aeCanvas ].

	self geometry aeApplyTo: aeCanvas element: self.

	aeCanvas setBackgroundWith: [
		self flag: #todo. "Create API in AeCanvas OR support in BlImageBackground (https://github.com/pharo-graphics/Bloc/issues/815"
		aeCanvas privateAeCairoContext sourceSurface: surface ].

	self border aeApplyTo: aeCanvas element: self.

	aeCanvas drawFigureAndPrepareToClip: (self hasChildren and: [ self clipChildren ])
]

{ #category : #accessing }
BASurfaceElement >> surface [

	^ surface
]

{ #category : #accessing }
BASurfaceElement >> surface: anAeCairoSurface [

	surface := anAeCairoSurface
]
