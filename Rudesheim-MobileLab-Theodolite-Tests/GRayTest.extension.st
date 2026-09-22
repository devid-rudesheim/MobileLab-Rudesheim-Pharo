Extension { #name : 'GRayTest' }

{ #category : '*Rudesheim-MobileLab-Theodolite-Tests' }
GRayTest >> testOriginBearingCardinalDirections [
	"GRay class >> origin:bearing: (added for Theodolite, see GRay.extension.st in
	Rudesheim-MobileLab-Theodolite) must reproduce the standard compass convention: 0=north,
	90=east, 180=south, 270=west, measured clockwise. Checked against known unit-vector directions
	rather than against the app's own bearing-computation formula
	(ModelTheodoliteMobileLabRudesheimTest>>#bearingFrom:toward:) -- the Model-level tests never
	assert an exact coordinate, so on their own they cannot catch a sign/axis mistake here (they
	would still pass if #origin:bearing: and #bearingFrom:toward: shared the same bug)."
	| origin |
	origin := 0 , 0.

	self
		assert: ((GRay origin: origin bearing: 0) directionPoint - origin) x
		closeTo: 0.
	self
		assert: ((GRay origin: origin bearing: 0) directionPoint - origin) y
		closeTo: 1.

	self
		assert: ((GRay origin: origin bearing: 90) directionPoint - origin) x
		closeTo: 1.
	self
		assert: ((GRay origin: origin bearing: 90) directionPoint - origin) y
		closeTo: 0.

	self
		assert: ((GRay origin: origin bearing: 180) directionPoint - origin) x
		closeTo: 0.
	self
		assert: ((GRay origin: origin bearing: 180) directionPoint - origin) y
		closeTo: -1.

	self
		assert: ((GRay origin: origin bearing: 270) directionPoint - origin) x
		closeTo: -1.
	self
		assert: ((GRay origin: origin bearing: 270) directionPoint - origin) y
		closeTo: 0.
]

{ #category : '*Rudesheim-MobileLab-Theodolite-Tests' }
GRayTest >> testOriginBearingIntersectionMatchesKnownGeometry [
	"Two rays built from hardcoded bearings (east from the origin, south from (10,10)) must cross
	at (10,0) -- a ground-truth check independent of any bearing-computation formula elsewhere in
	the app."
	| eastRay southRay intersection |
	eastRay := GRay
		origin:	0 , 0
		bearing:	90.
	southRay := GRay
		origin:	10 , 10
		bearing:	180.

	intersection := eastRay intersectionsWith: southRay.

	self assert: intersection size equals: 1.
	self assert: intersection first x closeTo: 10.
	self assert: intersection first y closeTo: 0.
]
