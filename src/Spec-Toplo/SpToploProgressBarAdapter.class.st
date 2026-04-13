Class {
	#name : #SpToploProgressBarAdapter,
	#superclass : #SpToploWidgetAdapter,
	#instVars : [
		'progressBar',
		'progressLabel',
		'lastRefresh',
		'refreshRateInMs',
		'refreshBlock',
		'process'
	],
	#category : #'Spec-Toplo-Adapters'
}

{ #category : #factory }
SpToploProgressBarAdapter >> buildWidget [

	^ ToProgressBar new
]

{ #category : #'updating widget' }
SpToploProgressBarAdapter >> progressBarState [

	^ self model state
]

{ #category : #initialization }
SpToploProgressBarAdapter >> subscribeToWidget [

	
]

{ #category : #'as yet unclassified' }
SpToploProgressBarAdapter >> updateFixedProgress [

	^ self widget valueInPercentage: self progressBarState value asFloat
]

{ #category : #'as yet unclassified' }
SpToploProgressBarAdapter >> updateInfiniteProgress [

	^ widget isInfinite: true
]

{ #category : #'as yet unclassified' }
SpToploProgressBarAdapter >> updateOngoingProgress [

"	process := [
		[ self progressBarState currentValue < 1 ] whileTrue: [
				self progressBarState currentValue:
					self progressBarState progression value.
				widget valueInPercentage: self progressBarState currentValue.
				self progressBarState refreshDelay wait ] ] fork"
]

{ #category : #'updating widget' }
SpToploProgressBarAdapter >> updateState [

	self widgetDo: [
			self progressBarState class = SpIndeterminatedProgressBarState
				ifTrue: [ self updateInfiniteProgress ]
				ifFalse: [
						self progressBarState class = SpFixedProgressBarState
							ifTrue: [ self updateFixedProgress ]
							ifFalse: [ self updateOngoingProgress ] ] ]
]
