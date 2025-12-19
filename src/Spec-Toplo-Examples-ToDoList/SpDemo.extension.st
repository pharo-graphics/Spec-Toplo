Extension { #name : #SpDemo }

{ #category : #'*Spec-Toplo-Examples-ToDoList' }
SpDemo class >> openInToplo [

	<script>
	| app demo |
	app := SpApplication new
		       useBackend: #Toplo;
		       yourself.

	demo := self newApplication: app.
	demo open.
	^ demo
]
