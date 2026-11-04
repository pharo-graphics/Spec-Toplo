"
I'm a Spec backend for Bloc.
"
Class {
	#name : #SpToploBackend,
	#superclass : #SpApplicationBackend,
	#instVars : [
		'host'
	],
	#category : #'Spec-Toplo-Base'
}

{ #category : #accessing }
SpToploBackend class >> backendName [

	^ #Toplo
]

{ #category : #private }
SpToploBackend >> adapterBindingsClass [
	
	^ SpToploAdapterBindings
]

{ #category : #accessing }
SpToploBackend >> componentListClass [

	^ SpComponentListPresenter
]

{ #category : #accessing }
SpToploBackend >> defaultConfigurationFor: aSpApplication [

	^ aSpApplication defaultConfigurationForToplo
]

{ #category : #ui }
SpToploBackend >> defer: aBlockClosure [
	"Enqueue aBlockClosure from any process to be executed in the UI process at the beginning of the next pulse."

	self host defer: aBlockClosure
]

{ #category : #accessing }
SpToploBackend >> diffClass [

	^ SpDiffPresenter
]

{ #category : #accessing }
SpToploBackend >> dropListClass [

	^ SpDropListPresenter
]

{ #category : #accessing }
SpToploBackend >> host [

	^ host ifNil: [ host := Bloc preferredHost ]
]

{ #category : #accessing }
SpToploBackend >> host: aHost [

	host := aHost
]

{ #category : #'ui - dialogs' }
SpToploBackend >> inform: aMsg [
]

{ #category : #accessing }
SpToploBackend >> listClass [

	^ SpListPresenter
]

{ #category : #private }
SpToploBackend >> openInnerWindow: aToInnerWindow on: aSpApplication [

	self flag: #todo. "Fix!"

	aSpApplication windows
		detect: [ :each | each adapter class = SpToploWindowAdapter ]
		ifFound: [ :each | each adapter widget root content addChild: aToInnerWindow ]
]

{ #category : #accessing }
SpToploBackend >> runOn: anApplication [
	"this is an adpater coming from recent version of Spec (> pharo 13)"
	^ anApplication start
]

{ #category : #accessing }
SpToploBackend >> tableClass [

	^ SpTablePresenter
]

{ #category : #accessing }
SpToploBackend >> treeClass [

	^ SpTreePresenter
]

{ #category : #accessing }
SpToploBackend >> treeTableClass [

	^ SpTreeTablePresenter
]

{ #category : #accessing }
SpToploBackend >> useInnerWindowAdapter [
	
	adapterBindings useInnerWindowAdapter 
]
