"
A MapDrawingTheodoliteMobileLabRudesheim holds one redraw's worth of context for Theodolite's
self-drawn map (WidgetsTheodoliteMobileLabRudesheim>>#mapArea, an SpAthensPresenter -- decision
recorded in NocoDB Sections 項番GM, 2026-09-25): `lines` (the current
BearingLinesTheodoliteMobileLabRudesheim), `bounds`/`extent`/`scale` (the world-to-canvas-pixel fit
that must stay fully visible), and `canvas`. Reached as `Rudesheim MobileLab Theodolite MapDrawing`.
Built by class-side #renderersFor:canvas: (a 0-or-1-element array of ready-to-use renderers, one
per fitted bounds -- mirrors #worldBoundsFor:'s own shape so a caller never sees the intermediate
Rectangle) and consumed directly in SpecBuilderTheodoliteMobileLabRudesheim>>#bindModel:toView:'s
mapArea `drawBlock:` (there is exactly one caller, so no separate stateless entry-point method
exists for that wiring either), then handed as a plain argument to
RaysTheodoliteMobileLabRudesheim/MarkersTheodoliteMobileLabRudesheim -- the two things that
actually draw, dispatched polymorphically via their shared class-side #drawOn: (both stateless,
per this project's 'prefer polymorphism over switch/if on kind' and 'put self-free logic on the
class side' conventions, ~/.claude/CLAUDE.md's Design section) rather than being two named methods
on one class.

`extent` is not a separate argument anywhere in this chain: it is always derivable from `canvas`
alone (#defaultExtent reads `canvas surface extent`, which Athens keeps equal to the presenter's
own `surfaceExtent`, per SpAthensPresenter>>#surfaceExtent:'s comment), so the only two things that
must actually be handed in from outside are the domain data (`lines`) and the one thing nothing
else can supply (`canvas`, which only exists because Athens itself passes it into `drawBlock:`).

Instance state exists specifically to stop `bounds`/`extent`/`canvas` (unchanging within one
redraw) from being threaded as identical arguments through every drawing method (#screenPointFor:
alone used to take all three, at every call site, before this class existed) -- Rays/Markers read
them off the renderer argument #drawOn: hands them instead. `scale` and `extent` are both normally
left to their
lazy defaults (#defaultScale from `bounds`/`extent`; #defaultExtent from `canvas`) --
#scale:/#extent: exist only so a test can pin either one directly, independently of what it would
otherwise be derived from.

Split so the geometry is still unit-testable without an actual Athens surface: class-side
#worldBoundsFor: (a 0-or-1-element array, never nil per the project's no-nil convention --
~/.claude/CLAUDE.md's Design section -- holding the Rectangle that must stay fully visible: every
recorded line's origin plus the current intersection point, if any) and #scaleToFit:inExtent: stay
pure class-side functions with no Athens dependency. #screenPointFor: is instance-side (it needs
`bounds`/`extent`/`scale` together, exactly the duplication being removed), but a test can still
construct a bare instance and set #bounds:/#extent: (or #bounds:/#scale:) directly on it --
#screenPointFor: never touches `canvas`/`lines`, so those can stay unset for a pure-geometry test.
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
canvas: aCanvasAthensCanvas [
	^ self new
		lines:	aLinesBearingLinesTheodoliteMobileLabRudesheim;
		bounds:	aBoundsRectangle;
		canvas:	aCanvasAthensCanvas;
		yourself.
]

{ #category : 'instance creation' }
MapDrawingTheodoliteMobileLabRudesheim class >> renderersFor: aLinesBearingLinesTheodoliteMobileLabRudesheim
canvas: aCanvasAthensCanvas [
	"0-or-1-element array (mirrors #worldBoundsFor:'s own shape) of ready-to-use renderers -- one
	per fitted bounds -- so a caller never has to see the intermediate Rectangle at all."
	^
	(
		self
			worldBoundsFor:	aLinesBearingLinesTheodoliteMobileLabRudesheim
	)
		collect:
		[ :bounds |
			self
				lines:	aLinesBearingLinesTheodoliteMobileLabRudesheim
				bounds:	bounds
				canvas:	aCanvasAthensCanvas.
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
MapDrawingTheodoliteMobileLabRudesheim >> defaultExtent [
	^ self canvas surface extent.
]

{ #category : 'private' }
MapDrawingTheodoliteMobileLabRudesheim >> defaultScale [
	^ self class
		scaleToFit:	self bounds
		inExtent:	self extent.
]

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheim >> extent [
	^ extent
		ifNil:
		[
			extent := self defaultExtent.
		].
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
