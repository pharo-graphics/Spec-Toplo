Class {
	#name : 'SpToploLayoutAdapter',
	#superclass : 'SpToploAdapter',
	#instVars : [
		'layout'
	],
	#category : 'Spec-Toplo-Adapters',
	#package : 'Spec-Toplo',
	#tag : 'Adapters'
}

{ #category : 'factory' }
SpToploLayoutAdapter >> buildWidget [
	
	^ nil
]

{ #category : 'protocol' }
SpToploLayoutAdapter >> layout: aLayout [

	layout := aLayout.
	widget := self newToploWidget.
	self updateWidgetFromLayout
]

{ #category : 'instance creation' }
SpToploLayoutAdapter >> newToploWidget [
	"Answer the new Toplo widget."

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
SpToploLayoutAdapter >> updateWidgetFromLayout [
	"Prepare widget based on layout specifications before adding children."

	self subclassResponsibility
]
