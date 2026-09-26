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

`lines`/`bounds`/`extent` have no sensible lazy default (unlike `scale`, there is nothing to derive
them from on a bare instance), so a plain `new` would answer an unusable renderer that raises
`nil doesNotUnderstand:` on its very first #screenPointFor: -- TShouldntNewRudesheim blocks `new`
outright instead, and #renderersFor:canvas: (the sole production constructor) uses `super new` to
get past that guard; a test wanting a bare instance for #screenPointFor: alone does the same via
`basicNew`.
"
Class {
	#name : 'RendererTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#traits : 'TShouldntNewRudesheim',
	#classTraits : 'TShouldntNewRudesheim classTrait',
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
			super new
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
		bounds
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

	"points are GRay>>#initialPoint/BearingLines>>#intersectionPoint's actual answer, GPoint, not
	plain kernel Point -- GPoint has no #min:/#max: (confirmed by a real `doesNotUnderstand: #min:`
	on CI; #x/#y is what's actually guaranteed on it, and #asPoint is GPoint's own conversion to a
	real Point using exactly that). Rectangle class>>#encompassing: already is the 'smallest
	Rectangle enclosing these points' operation, so it is reused here rather than hand-rolling the
	same per-axis min/max reduction again -- but #encompassing: itself sends #min:/#max: straight to
	the points it's given, so each point is converted to a plain Point first (a Point's #min:/#max:
	are componentwise) before being handed to it."
	bounds :=
		Rectangle
			encompassing:
			(
				points
					collect:	#asPoint
			).

	"A degenerate (zero-width and/or zero-height) box -- one point, or several exactly-coincident
	points -- is padded to a minimum span so a scale can always be computed from it; the padding
	threshold itself still has to look at width and height separately -- it decides, independently
	per axis, whether that axis is degenerate."
	padding :=
		{
			bounds width.
			bounds height
		}
			collect:
			[ :span |
				span < 0.0001
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
		bounds
			expandBy:	paddingPoint
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
