"
A MapDrawingTheodoliteMobileLabRudesheimTest tests the pure geometry
MapDrawingTheodoliteMobileLabRudesheim splits out from its actual Athens canvas calls (NocoDB
Sections 項番GM): #worldBoundsFor: (the fit-to-bounds requirement -- every origin plus the current
intersection point must stay in frame), #scaleToFit:inExtent: and
#screenPointFor:bounds:scale:extent:. The Athens-calling methods (#drawBearingLines:extent:on: and
friends) are not covered here -- they need a real surface, out of scope for a headless SUnit run.
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

{ #category : 'tests' }
MapDrawingTheodoliteMobileLabRudesheimTest >> testScreenPointForCenterMapsToCanvasCenter [
	|
		bounds
		screenPoint
	|

	bounds :=
		0 @ 0
			corner:	100 @ 100.

	screenPoint :=
		self targetClass
			screenPointFor:	50 @ 50
			bounds:	bounds
			scale:	2
			extent:	200 @ 200.

	self
		assert:	screenPoint
		equals:	100 @ 100.
]

{ #category : 'tests' }
MapDrawingTheodoliteMobileLabRudesheimTest >> testScreenPointForFlipsYSoWorldNorthDrawsUpward [
	|
		bounds
		screenPoint
	|

	bounds :=
		0 @ 0
			corner:	100 @ 100.

	screenPoint :=
		self targetClass
			screenPointFor:	50 @ 60
			bounds:	bounds
			scale:	2
			extent:	200 @ 200.

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
