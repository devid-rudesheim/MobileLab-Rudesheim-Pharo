"
A MapDrawingTheodoliteMobileLabRudesheimTest tests the pure geometry
MapDrawingTheodoliteMobileLabRudesheim splits out from its actual Athens canvas calls (NocoDB
Sections 項番GM): class-side #worldBoundsFor: (the fit-to-bounds requirement -- every origin plus
the current intersection point must stay in frame), #scaleToFit:inExtent: and
#renderersFor:canvas: (a 0-or-1-element array of ready renderers -- `canvas:`'s setter only checks
non-nil, so a plain `Object new` stands in for a real AthensCanvas here), plus instance-side
#screenPointFor: (needs only #bounds:/#extent: set -- it never touches #canvas:/#lines:, so a test
can build a bare instance for it without a real Athens surface). The actual Athens-calling drawing
lives on RaysTheodoliteMobileLabRudesheim/MarkersTheodoliteMobileLabRudesheim's stateless
class-side #drawOn:, which does need a real surface -- out of scope for a headless SUnit run, and
with no accessor contract of their own left to cover now that they take the renderer as a plain
argument instead of holding it as instance state.
"
Class {
	#name : 'MapDrawingTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
MapDrawingTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite MapDrawing.
]

{ #category : 'private' }
MapDrawingTheodoliteMobileLabRudesheimTest >> bearingFrom: anOrigin
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

{ #category : 'tests' }
MapDrawingTheodoliteMobileLabRudesheimTest >> testScaleToFitPicksSmallerAxisWithMargin [
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

{ #category : 'private' }
MapDrawingTheodoliteMobileLabRudesheimTest >> rendererWithBounds: aRectangle
extent: aPoint
scale: aNumber [
	"A bare instance with only #bounds:/#extent:/#scale: set -- enough for #screenPointFor:, which
	never touches #canvas:/#lines:, without needing a real Athens surface. #scale: pins an exact
	scale independently of #scaleToFit:inExtent:'s own margin math, which has its own test."
	^ self targetClass new
		bounds:	aRectangle;
		extent:	aPoint;
		scale:	aNumber;
		yourself.
]

{ #category : 'tests' }
MapDrawingTheodoliteMobileLabRudesheimTest >> testScreenPointForCenterMapsToCanvasCenter [
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
MapDrawingTheodoliteMobileLabRudesheimTest >> testScreenPointForFlipsYSoWorldNorthDrawsUpward [
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
MapDrawingTheodoliteMobileLabRudesheimTest >> testWorldBoundsForLinesAndIntersectionSpansAll [
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
MapDrawingTheodoliteMobileLabRudesheimTest >> testRenderersForNoLinesIsEmpty [
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
MapDrawingTheodoliteMobileLabRudesheimTest >> testRenderersForSingleLineBuildsOneRendererWithMatchingLinesAndCanvas [
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

	canvas := Object new.

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
		assert:	renderers first canvas
		equals:	canvas.
]

{ #category : 'tests' }
MapDrawingTheodoliteMobileLabRudesheimTest >> testWorldBoundsForNoLinesIsEmpty [
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
MapDrawingTheodoliteMobileLabRudesheimTest >> testWorldBoundsForSingleLineIsPaddedAroundOrigin [
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
