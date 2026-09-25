"
A RendererTheodoliteMobileLabRudesheimTest tests the pure geometry
RendererTheodoliteMobileLabRudesheim splits out from its actual Athens canvas calls (NocoDB
Sections 項番GM): class-side #worldBoundsFor: (the fit-to-bounds requirement -- every origin plus
the current intersection point must stay in frame), #scaleToFit:inExtent: and
#renderersFor:canvas: (a 0-or-1-element array of ready renderers --
StubAthensCanvasTheodoliteMobileLabRudesheim stands in for a real AthensCanvas, exposing just
`surface extent`), plus instance-side #screenPointFor: (needs only #bounds:/#extent: set, so a
test can build a bare instance for it without a real Athens surface -- this class holds no
`canvas` at all, so there is nothing to leave unset). The actual Athens-calling drawing lives on
RaysTheodoliteMobileLabRudesheim/MarkersTheodoliteMobileLabRudesheim's #drawOnAthensCanvas:, which
does need a real surface -- out of scope for a headless SUnit run.
"
Class {
	#name : 'RendererTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
RendererTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite Renderer.
]

{ #category : 'private' }
RendererTheodoliteMobileLabRudesheimTest >> bearingFrom: anOrigin
toward: aTarget [
	"Duplicated from ModelTheodoliteMobileLabRudesheimTest -- see that method's comment for why
	dividing the atan2-form radians straight by 360 already lands on Rudesheim-MobileLab's
	normalized bearing form without a separate wrap step."
	|
		delta
		radians
		degrees
	|

	delta := aTarget - anOrigin.

	radians :=
		delta x
			arcTan:	delta y.

	degrees := radians * 180 / Float pi.
	^ degrees / 360.
]

{ #category : 'private' }
RendererTheodoliteMobileLabRudesheimTest >> rendererWithBounds: aRectangle
extent: aPoint
scale: aNumber [
	"A bare instance with only #bounds:/#extent:/#scale: set -- enough for #screenPointFor:, which
	never touches #lines:. #scale: pins an exact scale independently of #scaleToFit:inExtent:'s own
	margin math, which has its own test. #basicNew, not #new: TShouldntNewRudesheim blocks #new since
	#lines:/#bounds:/#extent: have no lazy default outside #renderersFor:canvas:."
	^ self targetClass basicNew
		bounds:	aRectangle;
		extent:	aPoint;
		scale:	aNumber;
		yourself.
]

{ #category : 'tests' }
RendererTheodoliteMobileLabRudesheimTest >> testRenderersForNoLinesIsEmpty [
	|
		lines
	|

	lines := Rudesheim MobileLab Theodolite BearingLines new.

	self
		assert:
		(
			self targetClass
				renderersFor:	lines
				canvas:	Object new
		) isEmpty.
]

{ #category : 'tests' }
RendererTheodoliteMobileLabRudesheimTest >> testRenderersForSingleLineBuildsOneRendererWithMatchingLinesAndExtent [
	|
		lines
		canvas
		renderers
	|

	lines := Rudesheim MobileLab Theodolite BearingLines new.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	canvas := StubAthensCanvasTheodoliteMobileLabRudesheim new.

	renderers :=
		self targetClass
			renderersFor:	lines
			canvas:	canvas.

	self
		assert:	renderers size
		equals:	1.

	self
		assert:	renderers first lines
		equals:	lines.

	self
		assert:	renderers first extent
		equals:	canvas surface extent.
]

{ #category : 'tests' }
RendererTheodoliteMobileLabRudesheimTest >> testScaleToFitPicksSmallerAxisWithMargin [
	|
		bounds
		scale
	|

	bounds :=
		0 @ 0
			corner:	100 @ 50.

	scale :=
		self targetClass
			scaleToFit:	bounds
			inExtent:	200 @ 200.

	"min(200/100, 200/50) * 0.85 = min(2, 4) * 0.85 = 1.7"
	self
		assert:	scale
		closeTo:	1.7.
]

{ #category : 'tests' }
RendererTheodoliteMobileLabRudesheimTest >> testScreenPointForCenterMapsToCanvasCenter [
	|
		renderer
		screenPoint
	|

	renderer :=
		self
			rendererWithBounds:
			(
				0 @ 0
					corner:	100 @ 100
			)
			extent:	200 @ 200
			scale:	2.

	screenPoint :=
		renderer
			screenPointFor:	50 @ 50.

	self
		assert:	screenPoint
		equals:	100 @ 100.
]

{ #category : 'tests' }
RendererTheodoliteMobileLabRudesheimTest >> testScreenPointForFlipsYSoWorldNorthDrawsUpward [
	|
		renderer
		screenPoint
	|

	renderer :=
		self
			rendererWithBounds:
			(
				0 @ 0
					corner:	100 @ 100
			)
			extent:	200 @ 200
			scale:	2.

	screenPoint :=
		renderer
			screenPointFor:	50 @ 60.

	"10 world units north of center (bigger y) must draw with a *smaller* screen y (higher up)."
	self
		assert:	screenPoint
		equals:	100 @ 80.
]

{ #category : 'tests' }
RendererTheodoliteMobileLabRudesheimTest >> testWorldBoundsForLinesAndIntersectionSpansAll [
	|
		lines
		target
		bounds
	|

	lines := Rudesheim MobileLab Theodolite BearingLines new.
	target := 100 , 50.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:
				(
					self
						bearingFrom:	0 , 0
						toward:	target
				)
		).

	lines
		add:
		(
			GRay
				origin:	200 , 0
				normalizedBearing:
				(
					self
						bearingFrom:	200 , 0
						toward:	target
				)
		).

	self
		assert:	lines intersectionPoint size
		equals:	1.

	bounds :=
		(
			self targetClass
				worldBoundsFor:	lines
		) first.

	"origins (0,0)/(200,0) plus the intersection (~100,50) -- the fitted box must cover all three."
	self
		assert:	bounds origin x
		closeTo:	0.

	self
		assert:	bounds origin y
		closeTo:	0.

	self
		assert:	bounds corner x
		closeTo:	200.

	self
		assert:	bounds corner y
		closeTo:	50.
]

{ #category : 'tests' }
RendererTheodoliteMobileLabRudesheimTest >> testWorldBoundsForNoLinesIsEmpty [
	|
		lines
	|

	lines := Rudesheim MobileLab Theodolite BearingLines new.

	self
		assert:
		(
			self targetClass
				worldBoundsFor:	lines
		) isEmpty.
]

{ #category : 'tests' }
RendererTheodoliteMobileLabRudesheimTest >> testWorldBoundsForSingleLineIsPaddedAroundOrigin [
	|
		lines
		bounds
	|

	lines := Rudesheim MobileLab Theodolite BearingLines new.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	bounds :=
		(
			self targetClass
				worldBoundsFor:	lines
		) first.

	"A single point is a zero-area box; it must be padded to a non-zero span so a scale can be
	computed from it, and that span must still be centered on the origin."
	self
		assert:	bounds width > 0.

	self
		assert:	bounds height > 0.

	self
		assert:	bounds center x
		closeTo:	0.

	self
		assert:	bounds center y
		closeTo:	0.
]
