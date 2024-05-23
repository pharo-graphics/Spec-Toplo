Class {
	#name : 'SpToploMenuAdapter',
	#superclass : 'SpToploAdapter',
	#category : 'Spec-Toplo-Adapters',
	#package : 'Spec-Toplo',
	#tag : 'Adapters'
}

{ #category : 'factory' }
SpToploMenuAdapter >> buildWidget [

	^ ToContextMenu new
]
