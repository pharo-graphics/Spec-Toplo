Extension { #name : #StFinderPresenter }

{ #category : #'*Spec-Toplo-Examples' }
StFinderPresenter class >> openInToplo [
	<script>
	| model presenter app |
	
	model := StFinderModel new.
	app := StPharoApplication new.
	app useBackend: #Toplo.
	
	presenter := self 
		newApplication: app 
		model: model.

	model application: presenter application. 
	presenter open.
	
	^ presenter
]
