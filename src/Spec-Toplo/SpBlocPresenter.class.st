Class {
	#name : #SpBlocPresenter,
	#superclass : #SpAbstractWidgetPresenter,
	#instVars : [
		'#blocElement => ObservableSlot'
	],
	#category : #'Spec-Toplo-Presenters'
}

{ #category : #specs }
SpBlocPresenter class >> adapterName [

	^ #BlocAdapter
]

{ #category : #accessing }
SpBlocPresenter >> blocElement [

	^ blocElement
]

{ #category : #accessing }
SpBlocPresenter >> blocElement: aBlElement [ 

	blocElement := aBlElement
]

{ #category : #initialization }
SpBlocPresenter >> initialize [

	self class initializeSlots: self.
	super initialize.
]

{ #category : #enumerating }
SpBlocPresenter >> whenBlocElementChangedDo: aBlock [ 
	"Inform when Bloc element has changed. 
	 `aBlock` has three optional arguments: 
	 - new value
	 - old value
	 - the announcement triggering this action"

	self property: #blocElement whenChangedDo: aBlock
]
