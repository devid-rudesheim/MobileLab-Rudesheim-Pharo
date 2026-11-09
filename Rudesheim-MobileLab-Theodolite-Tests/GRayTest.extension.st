Extension { #name : 'GRayTest' }

{ #category : '*Rudesheim-MobileLab-Theodolite-Tests' }
GRayTest >> testOriginNormalizedBearingCardinalDirections [
	"GRay class >> origin:normalizedBearing: (added for Theodolite, see GRay.extension.st in
	Rudesheim-MobileLab) must reproduce the standard compass convention on Rudesheim-MobileLab's
	normalized bearing form: 0.0=north, 0.25=east, 0.5=south, -0.25=west, measured clockwise.
	Checked against known unit-vector directions rather than against the app's own
	bearing-computation formula (ModelTheodoliteMobileLabRudesheimTest>>#bearingFrom:toward:) -- the
	Model-level tests never assert an exact coordinate, so on their own they cannot catch a
	sign/axis mistake here (they would still pass if #origin:normalizedBearing: and
	#bearingFrom:toward: shared the same bug)."
	|
		origin
	|

	origin := 0 , 0.

	self
		assert:
		(
			(
				GRay
					origin:	origin
					normalizedBearing:	0.0
			) directionPoint - origin
		) x
		closeTo:	0.

	self
		assert:
		(
			(
				GRay
					origin:	origin
					normalizedBearing:	0.0
			) directionPoint - origin
		) y
		closeTo:	1.

	self
		assert:
		(
			(
				GRay
					origin:	origin
					normalizedBearing:	0.25
			) directionPoint - origin
		) x
		closeTo:	1.

	self
		assert:
		(
			(
				GRay
					origin:	origin
					normalizedBearing:	0.25
			) directionPoint - origin
		) y
		closeTo:	0.

	self
		assert:
		(
			(
				GRay
					origin:	origin
					normalizedBearing:	0.5
			) directionPoint - origin
		) x
		closeTo:	0.

	self
		assert:
		(
			(
				GRay
					origin:	origin
					normalizedBearing:	0.5
			) directionPoint - origin
		) y
		closeTo:	-1.

	self
		assert:
		(
			(
				GRay
					origin:	origin
					normalizedBearing:	-0.25
			) directionPoint - origin
		) x
		closeTo:	-1.

	self
		assert:
		(
			(
				GRay
					origin:	origin
					normalizedBearing:	-0.25
			) directionPoint - origin
		) y
		closeTo:	0.
]

{ #category : '*Rudesheim-MobileLab-Theodolite-Tests' }
GRayTest >> testOriginNormalizedBearingIntersectionMatchesKnownGeometry [
	"Two rays built from hardcoded normalized bearings (east from the origin, south from (10,10))
	must cross at (10,0) -- a ground-truth check independent of any bearing-computation formula
	elsewhere in the app."
	|
		eastRay
		southRay
		intersection
	|

	eastRay :=
		GRay
			origin:	0 , 0
			normalizedBearing:	0.25.

	southRay :=
		GRay
			origin:	10 , 10
			normalizedBearing:	0.5.

	intersection :=
		eastRay
			intersectionsWith:	southRay.

	self
		assert:	intersection size
		equals:	1.

	self
		assert:	intersection first x
		closeTo:	10.

	self
		assert:	intersection first y
		closeTo:	0.
]
