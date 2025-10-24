Class {
	#name : #RSBlocExamplesWithParametricCanvas,
	#superclass : #Object,
	#category : #'Spec-Toplo-Roassal-RoassalPresenterExamples'
}

{ #category : #accessing }
RSBlocExamplesWithParametricCanvas class >> allExampleSelectors [

	^ (self selectors select: [ :each | each beginsWith: 'example' ])
		  sorted
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example01Boxes: c [

	c addShape: (RSBox new
		color: Color blue translucent;
		extent: 200 asPoint;
		yourself).
	c addShape: (RSBox new
		position: 100 asPoint;
		color: Color red translucent;
		extent: 200 asPoint;
		yourself).

	^ c
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example02EllipseAndCircle: c [


	c addShape: (RSEllipse new
			 color: Color green translucent;
			 extent: 100 asPoint;
			 position: -25 asPoint;
			 yourself).
	c addShape: (RSCircle new
			 color: Color red translucent;
			 extent: 100 asPoint;
			 position: 25 asPoint;
			 yourself).

	^ c
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example03RotatedBoxes: c [


	1 to: 12 do: [ :m |
		| angle theta p box |
		angle := (m * 360 / 12) degreesToRadians.
		theta := angle cos @ angle sin.
		p := theta * 100.
		box := RSBox new
			size: 90@45;
			yourself.
		angle := angle radiansToDegrees.
		angle := angle + ((angle between: 90 and: 270)
			ifTrue: [ 180 ]
			ifFalse: [ 0 ] ).

		box rotateByDegrees: angle.
		box position: p + ((box baseRectangle width/2) * theta).

		c addShape: box.
		].
	c addShape: (RSEllipse new
		color: nil;
		withBorder;
		radius: 90).

	^ c

]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example04RotatedLabels: c [

	| metricsProvider |
	metricsProvider := RSBlocMetricProvider new.
	1 to: 12 do: [ :m |
			| angle theta p label |
			angle := (m * 360 / 12) degreesToRadians.
			theta := angle cos @ angle sin.
			p := theta * 100.
			label := RSLabel new
				         metricsProvider: metricsProvider;
				         color: (Color purple alpha: 0.5);
				         fontName: 'Arial';
				         fontSize: 40;
				         text: (Month nameOfMonth: m);
				         yourself.
			angle := angle radiansToDegrees.
			angle := angle + ((angle between: 90 and: 270)
				          ifTrue: [ 180 ]
				          ifFalse: [ 0 ]).

			label rotateByDegrees: angle.
			label position: p + (label textWidth / 2 * theta).
			m even
				ifTrue: [ label bold ]
				ifFalse: [ label italic ].
			c addShape: label ].
	c addShape: (RSEllipse new
			 color: nil;
			 withBorder;
			 radius: 90).

	^ c
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example05Ellipses: c [

	| r y |
	r := Random new.
	c color: (Color colorFrom: '325A64').
	1 to: 500 do: [ :x |
			y := 255 + (x sin * 255).
			c addShape: (RSEllipse new
					 color: Color transparent;
					 border: (RSBorder new
							  width: x / 50;
							  color: (Color
									   r: r next * 255
									   g: r next * 200
									   b: 255
									   range: y));
					 position: x * 2 @ y - 250;
					 extent: y / 10 @ (x * 75 / 499)) ].
	^ c
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example06Polyline: c [

	c addShape: (RSPolyline new
		width: 30;
		joinRound;"joinBevel; joinMiter"
		color: Color blue;
		paint: Color green translucent;
		controlPoints: { 50@300. 150@300. 150@200. 250@200. 250@100. 350@100};
		basicTranslateBy: -250 @ -250;
		yourself).
	^ c

]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example07MouseMove: canvas [

	| size circles box |
	box := RSBox new size: 200.
	canvas add: box.
	size := 200.
	canvas addAll:
		(circles := #( magenta yellow red cyan ) collect: [ :sel |
				            canvas add: (RSEllipse new
						             size: size;
						             color: ((Color perform: sel) alpha: 0.4);
						             yourself) ]).
	box
		when: RSMouseEnter
		do: [ :evt |
				box color: Color random.
				canvas signalUpdate ]
		for: self.
	canvas
		when: RSMouseMove
		do: [ :evt |
				| posOffset negOffset |
				posOffset := evt position distanceTo: 0 @ 0.
				negOffset := posOffset negated.
				circles first position: posOffset @ 0.
				circles second position: 0 @ posOffset.
				circles third position: negOffset @ 0.
				circles fourth position: 0 @ negOffset.
				canvas signalUpdate ]
		for: self.
	^ canvas
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example08ZoomToFitWhenExtentChangedEvent: canvas [

	canvas add: (RSBox new
			 color: Color blue;
			 position: 100 asPoint;
			 size: 5000 @ 3000;
			 yourself).

	canvas
		when: RSExtentChangedEvent
		do: [ :event |
				canvas zoomToFit.
				canvas signalUpdate ]
		for: self.

	^ canvas
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example09HierarchyWithCanvasController: canvas [

	| color shapes |
	color := NSScale linear
		         domain: { 1. 200. 400 };
		         range: #( white gray red ).

	shapes := Collection withAllSubclasses collect: [ :cls |
			          RSBox new
				          model: cls;
				          color: (color scale: cls numberOfMethods);
				          draggable;
				          size: cls linesOfCode sqrt + 10;
				          borderColor: Color black;
				          yourself ].
	canvas addAll: shapes.

	RSLineBuilder orthoVertical
		withVerticalAttachPoint;
		shapes: shapes;
		connectFrom: #superclass.

	RSTreeLayout on: shapes.

	canvas addInteraction: RSCanvasController new.
	^ canvas
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example10BasicComposite: c [

	| com |
	com := RSComposite new.
	com add: (RSBox new
			 color: (Color gray alpha: 0.4);
			 extent: 100 @ 100;
			 yourself).
	com add: (RSBox new
			 position: 100 @ 100;
			 color: (Color red alpha: 0.4);
			 extent: 100 @ 100;
			 yourself).

	c addShape: com.
	c addShape: (RSEllipse new
			 color: (Color gray alpha: 0.4);
			 extent: 100 @ 100;
			 yourself).
	c addShape: (RSEllipse new
			 position: 100 @ 100;
			 color: (Color red alpha: 0.4);
			 extent: 100 @ 100;
			 yourself).
	^ c
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example11SimpleClassHierarchy: c [

	| methods |

	String withAllSubclassesDo: [ :cls |
		| composite |
		methods := cls methods collect: [ :m | RSBox new color: Color red; size: 5; model: m; yourself ] as: RSGroup.

		RSGridLayout on: methods.
		composite := RSComposite new.
		composite shapes:  methods.
		
		composite color: Color gray.
		composite model: cls.
		composite padding: 30.
		c add: composite ].

	RSLineBuilder line
		canvas: c;
		withVerticalAttachPoint;
		color: Color blue;
		connectFrom: #superclass.

	RSTreeLayout on: c nodes.

	"Making sure we have zooming"
	c @ RSCanvasController.
	
	^ c 
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example12Donna: canvas [

    | text horizontal vertical groups count metricsProvider |
    text := 'La donna è mobile
Qual piuma al vento
Muta d''accento
E di pensiero

Sempre un amabile
Leggiadro viso
In pianto o in riso
È menzognero

La donna è mobile
Qual piuma al vento
Muta d''accento
E di pensier
E di pensier
E di pensier

È sempre misero
Chi a lei s''affida
Chi le confida
Mal cauto il core

Pur mai non sentesi
Felice appieno
Chi su quel seno
Non liba amore

La donna è mobile
Qual piuma al vento
Muta d''accento
E di pensier
E di pensier
E di pensier
'.
    count := 0.
    vertical := RSVerticalLineLayout new gapSize: 0.
    horizontal := RSHorizontalLineLayout new alignLabel.
    metricsProvider := RSBlocMetricProvider new.
    groups := (text splitOn: String cr,String cr) collect: [ :p | 
        | lines |
        lines := p lines collect: [ :line |
            | words |
            words := (line splitOn: ' ') collect: [ :word | 
                RSLabel new
                    text: word;
						  metricsProvider: metricsProvider;
                    ifNotNil: [ :lbl |
                        word = 'donna' 
                            ifTrue: [ lbl bold; fontSize: 14 ].
                        word = 'misero' 
                            ifTrue: [ lbl fontSize: 20; color: 'red' ].
                        word = 'pensier'
                            ifTrue: [ 
                                lbl italic; underline; color: 'blue'; fontSize: (count*4)+10.
                                count := count+1.  ]
                         ];
                    yourself
                ].
            horizontal on: words.
            words asGroup asShape
             ].
        vertical on: lines.
        
        lines asGroup asShape.
        ].

    canvas addAll: groups.
    RSHorizontalFlowLayout new
        gapSize: 30;
        on: groups.
    canvas @ RSCanvasController.
    ^ canvas
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example13Cluster: canvas [

	| shapes |
	
	canvas addAll: (#(linear sqrt) collect: [ :scale | 
		| group |
		group := RSGroup new.
		shapes :=  Collection withAllSubclasses collect: [ :cls |
			RSEllipse new 
				size: 5;
				draggable;
				color: Color red;
				model: cls;
				yourself ].
		group addAll: shapes.
		RSLineBuilder line
			color: Color blue translucent;
			canvas: group;
			shapes: shapes;
			connectFrom: #superclass.
		
		RSNormalizer size
			scale: (NSScale perform: scale);
			from: 1;
			to: 30;
			shapes: shapes;
			normalize: #numberOfMethods.
		RSNormalizer color
			scale: (NSScale perform: scale);
			from: Color blue;
			to: Color red;
			shapes: shapes;
			normalize: #numberOfMethods.
		RSClusterTreeLayout on: shapes.
		RSComposite new
			color: Color veryLightGray translucent;
			model: scale;
			labeled;
			draggable;
			shapes: group;
			yourself.
		]).
	RSGridLayout new gapSize: 20; on: canvas nodes.
	canvas @ RSCanvasController.

	^ canvas
]

{ #category : #examples }
RSBlocExamplesWithParametricCanvas >> example14LabelExtent: canvas [

	| aString metricsProvider |
	metricsProvider := RSBlocMetricProvider new.
	aString := (String loremIpsum: 40) trimBoth.

	10 to: 100 by: 5 do: [ :each |
		| aLabel |
		aLabel := RSLabel new
			fontName: 'Courier';
			fontSize: each;
			text: aString;
			color: Color black;
			metricsProvider: metricsProvider;
			yourself.
		canvas addShape: (RSComposite new 
			color: Color cyan translucent;
			extent: aLabel extent;
			addShape: aLabel;
			yourself).

	].

	RSVerticalLineLayout on: canvas shapes.
	canvas @ RSCanvasController.

	^ canvas

]
