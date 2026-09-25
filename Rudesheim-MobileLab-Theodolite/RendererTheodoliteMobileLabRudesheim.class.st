"
A RendererTheodoliteMobileLabRudesheim holds one redraw's worth of fit context for Theodolite's
self-drawn map (WidgetsTheodoliteMobileLabRudesheim>>#mapArea, an SpAthensPresenter -- decision
recorded in NocoDB Sections 項番GM, 2026-09-25): `lines` (the current
BearingLinesTheodoliteMobileLabRudesheim) and `bounds`/`extent`/`scale` (the world-to-canvas-pixel
fit that must stay fully visible). Reached as `Rudesheim MobileLab Theodolite Renderer`.

Holds no `canvas`: it only exists to answer #screenPointFor: (needs `bounds`/`extent`/`scale`
together -- the duplication this class exists to remove, #screenPointFor: alone used to take all
three as explicit arguments at every call site before this class existed), which never touches a
canvas. `canvas` is instead a plain per-call argument to
RaysTheodoliteMobileLabRudesheim/MarkersTheodoliteMobileLabRudesheim's #drawOnAthensCanvas: -- the
one thing that only exists transiently, for the duration of Athens' own paint callback -- while a
renderer (built once per fitted bounds by class-side #renderersFor:canvas:) is handed to both of
them at construction and kept for the rest of that #drawOnAthensCanvas: call.

Built by class-side #renderersFor:canvas: (a 0-or-1-element array of ready-to-use renderers, one
per fitted bounds -- mirrors #worldBoundsFor:'s own shape so a caller never sees the intermediate
Rectangle) and consumed directly in SpecBuilderTheodoliteMobileLabRudesheim>>#bindModel:toView:'s
mapArea `drawBlock:` (there is exactly one caller, so no separate stateless entry-point method
exists for that wiring either). `extent` is read from the canvas Athens hands into `drawBlock:`
right there in #renderersFor:canvas: (`aCanvas surface extent`, which Athens keeps equal to the
presenter's own `surfaceExtent`, per SpAthensPresenter>>#surfaceExtent:'s comment) and stored on
the renderer as a plain value -- it does not need the canvas itself kept around afterward.

Split so the geometry is still unit-testable without an actual Athens surface: class-side
#worldBoundsFor: (a 0-or-1-element array, never nil per the project's no-nil convention --
~/.claude/CLAUDE.md's Design section -- holding the Rectangle that must stay fully visible: every
recorded line's origin plus the current intersection point, if any) and #scaleToFit:inExtent: stay
pure class-side functions with no Athens dependency. #screenPointFor: needs only #bounds:/#extent:
(or #bounds:/#scale:) set directly on a bare instance for a test to exercise it.
"
Class {
	#name : 'RendererTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'lines',
		'bounds',
		'extent',
		'scale'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'instance creation' }
RendererTheodoliteMobileLabRudesheim class >> renderersFor: aLinesBearingLinesTheodoliteMobileLabRudesheim
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
			self new
				lines:	aLinesBearingLinesTheodoliteMobileLabRudesheim;
				bounds:	bounds;
				extent:	aCanvasAthensCanvas surface extent;
				yourself.
		].
]

{ #category : 'geometry' }
RendererTheodoliteMobileLabRudesheim class >> scaleToFit: aBoundsRectangle
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
RendererTheodoliteMobileLabRudesheim class >> worldBoundsFor: aBearingLinesTheodoliteMobileLabRudesheim [
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
				into:	combine.
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
RendererTheodoliteMobileLabRudesheim >> bounds [
	^ bounds.
]

{ #category : 'accessing' }
RendererTheodoliteMobileLabRudesheim >> bounds: aRectangle [
	bounds := aRectangle assertNotNilRudesheim.
]

{ #category : 'private' }
RendererTheodoliteMobileLabRudesheim >> defaultScale [
	^ self class
		scaleToFit:	self bounds
		inExtent:	self extent.
]

{ #category : 'accessing' }
RendererTheodoliteMobileLabRudesheim >> extent [
	^ extent.
]

{ #category : 'accessing' }
RendererTheodoliteMobileLabRudesheim >> extent: aPoint [
	extent := aPoint assertNotNilRudesheim.
]

{ #category : 'accessing' }
RendererTheodoliteMobileLabRudesheim >> lines [
	^ lines.
]

{ #category : 'accessing' }
RendererTheodoliteMobileLabRudesheim >> lines: aBearingLinesTheodoliteMobileLabRudesheim [
	lines := aBearingLinesTheodoliteMobileLabRudesheim assertNotNilRudesheim.
]

{ #category : 'accessing' }
RendererTheodoliteMobileLabRudesheim >> scale [
	^ scale
		ifNil:
		[
			scale := self defaultScale.
		].
]

{ #category : 'accessing' }
RendererTheodoliteMobileLabRudesheim >> scale: aNumber [
	scale := aNumber assertNotNilRudesheim.
]

{ #category : 'geometry' }
RendererTheodoliteMobileLabRudesheim >> screenPointFor: aPoint [
	"World point -> canvas pixel point: self bounds' center maps to self extent's center, scaled
	by self scale, with Y flipped so world north (+y) draws upward -- (1@-1) flips only the y half
	of the already-componentwise Point multiplication (Point>>#*'s own comment)."
	^
	( self extent / 2 ) +
	(
		( ( aPoint - self bounds center ) ) * self scale * ( 1 @ -1 )
	).
]
