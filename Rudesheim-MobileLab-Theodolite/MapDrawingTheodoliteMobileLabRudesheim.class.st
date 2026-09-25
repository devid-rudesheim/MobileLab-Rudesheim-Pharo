"
A MapDrawingTheodoliteMobileLabRudesheim renders Theodolite's self-drawn map
(WidgetsTheodoliteMobileLabRudesheim>>#mapArea, an SpAthensPresenter -- decision recorded in
NocoDB Sections 項番GM, 2026-09-25) from the current BearingLinesTheodoliteMobileLabRudesheim.
Reached as `Rudesheim MobileLab Theodolite MapDrawing`. Class-side #drawBearingLines:extent:on: is
the stateless entry point wired from SpecBuilderTheodoliteMobileLabRudesheim>>#bindModel:toView:
as the mapArea's `drawBlock:`, re-invoked on every redraw the add/remove/discard action blocks
trigger; it always clears the canvas first (even with nothing to fit, so discarding the last line
blanks the map), then, for each fitted bounds, builds one instance -- an object identical for a
single redraw's worth of `lines`/`bounds`/`extent`/`canvas` -- and sends it #draw.

Instance state exists specifically to stop `bounds`/`extent`/`canvas` (unchanging within one
redraw) from being threaded as identical arguments through every drawing method (#screenPointFor:
alone used to take all three, at every call site); each drawing method now reads them via `self`
instead. `scale` is normally left to its lazy default, derived from `bounds`/`extent`
(#defaultScale) -- #scale: exists only so a test can pin an exact scale independently of
#scaleToFit:inExtent:'s own (separately tested) margin math.

Split so the geometry is still unit-testable without an actual Athens surface: class-side
#worldBoundsFor: (a 0-or-1-element array, never nil per the project's no-nil convention --
~/.claude/CLAUDE.md's Design section -- holding the Rectangle that must stay fully visible: every
recorded line's origin plus the current intersection point, if any) and #scaleToFit:inExtent: stay
pure class-side functions with no Athens dependency. #screenPointFor: became instance-side (it
needs `bounds`/`extent`/`scale` together, exactly the duplication being removed), but a test can
still construct a bare instance and set only #bounds:/#extent: on it -- #screenPointFor: never
touches `canvas`/`lines`, so those can stay unset for a pure-geometry test.

Each recorded line is drawn as a ray from its origin far enough to cross the fitted frame (a
multiple of the frame's own diagonal, not a fixed world length, since real GPS-scale coordinates
and GRayTest's synthetic ones differ by orders of magnitude) -- overflow past the presenter's own
bounds is left to ordinary Morphic clipping rather than an explicit #clipBy:during:, per this app's
thin-design convention (NocoDB Sections 項番FM/GM: no machinery beyond what a caller actually
needs).
"
Class {
	#name : 'MapDrawingTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'lines',
		'bounds',
		'extent',
		'canvas',
		'scale'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'instance creation' }
MapDrawingTheodoliteMobileLabRudesheim class >> lines: aLinesBearingLinesTheodoliteMobileLabRudesheim
bounds: aBoundsRectangle
extent: anExtentPoint
canvas: aCanvasAthensCanvas [
	^ self new
		lines:	aLinesBearingLinesTheodoliteMobileLabRudesheim;
		bounds:	aBoundsRectangle;
		extent:	anExtentPoint;
		canvas:	aCanvasAthensCanvas;
		yourself.
]

{ #category : 'drawing' }
MapDrawingTheodoliteMobileLabRudesheim class >> drawBearingLines: aLinesBearingLinesTheodoliteMobileLabRudesheim
extent: anExtentPoint
on: aCanvasAthensCanvas [
	aCanvasAthensCanvas surface clear.

	(
		self
			worldBoundsFor:	aLinesBearingLinesTheodoliteMobileLabRudesheim
	)
		do:
		[ :bounds |
			(
				self
					lines:	aLinesBearingLinesTheodoliteMobileLabRudesheim
					bounds:	bounds
					extent:	anExtentPoint
					canvas:	aCanvasAthensCanvas
			) draw.
		].
]

{ #category : 'geometry' }
MapDrawingTheodoliteMobileLabRudesheim class >> scaleToFit: aBoundsRectangle
inExtent: anExtentPoint [
	"Uniform world-units-to-pixels scale that fits aBoundsRectangle inside anExtentPoint with a
	15% margin, preserving aspect ratio."
	^
	(
		anExtentPoint x / aBoundsRectangle width
			min:	anExtentPoint y / aBoundsRectangle height
	) * 0.85.
]

{ #category : 'geometry' }
MapDrawingTheodoliteMobileLabRudesheim class >> worldBoundsFor: aBearingLinesTheodoliteMobileLabRudesheim [
	"0-or-1-element array (never nil, per the project's no-nil convention) holding the Rectangle
	enclosing every recorded line's origin plus the current intersection point, if any -- the set
	of points that must stay fully visible after every 'Add line' press. Empty when there is
	nothing to fit (no lines recorded yet)."
	|
		points
		extremes
		minPoint
		maxPoint
		padding
		paddingPoint
	|

	points :=
	(
		aBearingLinesTheodoliteMobileLabRudesheim asArray collect: #initialPoint
	) , aBearingLinesTheodoliteMobileLabRudesheim intersectionPoint.

	points
		ifEmpty:
		[
			^ #(  ).
		].

	"Point>>#min:/#max: are already componentwise (Point's own comment), so the two extremes come
	from one data-driven pass over the pair of combining blocks rather than two near-duplicate
	inject:into: reductions."
	extremes :=
	{
		[ :accumulator :each |
			accumulator
				min:	each.
		].
		[ :accumulator :each |
			accumulator
				max:	each.
		]
	}
		collect:
		[ :combine |
			points
				inject:	points first
				into:
				[ :accumulator :each |
					combine
						value:	accumulator
						value:	each.
				].
		].

	minPoint := extremes first.
	maxPoint := extremes last.

	"A degenerate (zero-width and/or zero-height) box -- one point, or several exactly-coincident
	points -- is padded per axis to a minimum span so a scale can always be computed from it; the
	padding threshold itself still has to look at x and y separately -- it decides, independently
	per axis, whether that axis is degenerate."
	padding :=
		#( #x #y )
			collect:
			[ :axis |
				(
					(
						axis
							value:	maxPoint
					) -
					(
						axis
							value:	minPoint
					)
				) < 0.0001
					ifTrue:
					[
						0.0005.
					]
					ifFalse:
					[
						0.
					].
			].

	paddingPoint := padding first @ padding last.

	^
	{
		minPoint - paddingPoint
			corner:	maxPoint + paddingPoint
	}.
]

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheim >> bounds [
	^ bounds.
]

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheim >> bounds: aRectangle [
	bounds := aRectangle assertNotNilRudesheim.
]

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheim >> canvas [
	^ canvas.
]

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheim >> canvas: anAthensCanvas [
	canvas := anAthensCanvas assertNotNilRudesheim.
]

{ #category : 'private' }
MapDrawingTheodoliteMobileLabRudesheim >> defaultScale [
	^ self class
		scaleToFit:	self bounds
		inExtent:	self extent.
]

{ #category : 'drawing' }
MapDrawingTheodoliteMobileLabRudesheim >> draw [
	self drawRays.
	self drawMarkers.
]

{ #category : 'private' }
MapDrawingTheodoliteMobileLabRudesheim >> drawMarker: aPointPoint
color: aColorColor [
	|
		radius
	|

	radius := 4.

	self canvas
		setPaint:	aColorColor.

	self canvas
		drawShape:
		(
			aPointPoint - radius
				corner:	aPointPoint + radius
		).
]

{ #category : 'private' }
MapDrawingTheodoliteMobileLabRudesheim >> drawMarkers [
	{
		{
			self lines asArray
				collect:	#initialPoint.
			Color blue
		}.
		{
			self lines intersectionPoint.
			Color red
		}
	}
		do:
		[ :pair |
			pair first
				do:
				[ :each |
					self
						drawMarker:
						(
							self
								screenPointFor:	each
						)
						color:	pair last.
				].
		].
]

{ #category : 'private' }
MapDrawingTheodoliteMobileLabRudesheim >> drawRays [
	|
		rayLength
	|

	rayLength :=
	(
		self extent x
			max:	self extent y
	) / self scale * 3.

	self lines asArray
		do:
		[ :each |
			|
				direction
				farPoint
				screenPoints
				path
			|

			direction := each directionPoint - each initialPoint.

			direction = ( 0 @ 0 )
				ifFalse:
				[
					farPoint := each initialPoint + ( direction / direction r * rayLength ).

					screenPoints :=
					{
						each initialPoint.
						farPoint
					}
						collect:
						[ :point |
							self
								screenPointFor:	point.
						].

					path :=
						self canvas
							createPath:
							[ :aBuilder |
								aBuilder
									absolute;
									moveTo:	screenPoints first;
									lineTo:	screenPoints last.
							].

					(
						self canvas
							setStrokePaint:	Color gray
					)
						width:	1.

					self canvas
						drawShape:	path.
				].
		].
]

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheim >> extent [
	^ extent.
]

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheim >> extent: aPoint [
	extent := aPoint assertNotNilRudesheim.
]

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheim >> lines [
	^ lines.
]

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheim >> lines: aBearingLinesTheodoliteMobileLabRudesheim [
	lines := aBearingLinesTheodoliteMobileLabRudesheim assertNotNilRudesheim.
]

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheim >> scale [
	^ scale
		ifNil:
		[
			scale := self defaultScale.
		].
]

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheim >> scale: aNumber [
	scale := aNumber assertNotNilRudesheim.
]

{ #category : 'geometry' }
MapDrawingTheodoliteMobileLabRudesheim >> screenPointFor: aPoint [
	"World point -> canvas pixel point: self bounds' center maps to self extent's center, scaled
	by self scale, with Y flipped so world north (+y) draws upward -- (1@-1) flips only the y half
	of the already-componentwise Point multiplication (Point>>#*'s own comment)."
	^
	( self extent / 2 ) +
	(
		( ( aPoint - self bounds center ) ) * self scale * ( 1 @ -1 )
	).
]
