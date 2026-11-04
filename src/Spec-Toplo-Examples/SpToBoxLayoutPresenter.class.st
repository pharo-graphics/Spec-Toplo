"
I show the border width, the spacing and the constraint padding of box layouts on the Toplo backend.

Each row is a label describing it and a horizontal box of three buttons that does not expand, so the size of the box is visible.

What to look at:
- the first box has no border and no spacing: the buttons touch each other;
- the second box uses #spacing: 10, the space is only between the buttons, not at the ends;
- the third box adds #borderWidth: 5, the box grows by twice the width; its border is transparent by default, so I paint it gray once built;
- the fourth box adds a padding of 8 around the middle button with #add:withConstraints:.

	SpToBoxLayoutPresenter openInToplo
"
Class {
	#name : #SpToBoxLayoutPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'noSpacingLabel',
		'noSpacingButtons',
		'spacingLabel',
		'spacingButtons',
		'borderLabel',
		'borderButtons',
		'paddingLabel',
		'paddingButtons'
	],
	#category : #'Spec-Toplo-Examples'
}

{ #category : #layout }
SpToBoxLayoutPresenter class >> openInToplo [

	<script>
	| app presenter |
	app := SpApplication new
		       useBackend: #Toplo;
		       yourself.
	presenter := self newApplication: app.
	presenter open.
	^ presenter
]

{ #category : #layout }
SpToBoxLayoutPresenter >> boxWith: buttons [

	| box |
	box := SpBoxLayout newHorizontal.
	buttons do: [ :each | box add: each expand: false ].
	^ box
]

{ #category : #layout }
SpToBoxLayoutPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: noSpacingLabel expand: false;
		  add: (self boxWith: noSpacingButtons) expand: false;
		  add: spacingLabel expand: false;
		  add: ((self boxWith: spacingButtons)
				   spacing: 10;
				   yourself)
		  expand: false;
		  add: borderLabel expand: false;
		  add: ((self boxWith: borderButtons)
				   borderWidth: 5;
				   spacing: 10;
				   yourself)
		  expand: false;
		  add: paddingLabel expand: false;
		  add: (SpBoxLayout newHorizontal
				   add: paddingButtons first expand: false;
				   add: paddingButtons second withConstraints: [ :constraints |
						   constraints
							   expand: false;
							   padding: 8 ];
				   add: paddingButtons third expand: false;
				   yourself)
		  expand: false;
		  yourself
]

{ #category : #initialization }
SpToBoxLayoutPresenter >> initializePresenters [

	noSpacingLabel := self newLabel label: 'No border, no spacing'.
	noSpacingButtons := self newButtons.
	spacingLabel := self newLabel label: 'Spacing 10'.
	spacingButtons := self newButtons.
	borderLabel := self newLabel label: 'Border 5 and spacing 10'.
	borderButtons := self newButtons.
	paddingLabel := self newLabel label: 'Padding 8 around the middle button'.
	paddingButtons := self newButtons.
	self whenBuiltDo: [ self showBorders ]
]

{ #category : #initialization }
SpToBoxLayoutPresenter >> newButtons [

	^ #( 'One' 'Two' 'Three' ) collect: [ :label |
			  self newButton
				  label: label;
				  yourself ]
]

{ #category : #initialization }
SpToBoxLayoutPresenter >> showBorders [
	"Box borders are transparent by default: paint them so they can be seen"

	self layout childLayouts do: [ :each | each borderWidth > 0 ifTrue: [ each adapter widget borderColor: Color gray ] ]
]
