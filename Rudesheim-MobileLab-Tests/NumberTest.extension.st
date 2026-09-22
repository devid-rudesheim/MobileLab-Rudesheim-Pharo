Extension { #name : 'NumberTest' }

{ #category : '*Rudesheim-MobileLab-Tests' }
NumberTest >> testAsNormalizedBearingRudesheimMatchesAtan2Convention [
	"Number>>#asNormalizedBearingRudesheim (Rudesheim-MobileLab's Number.extension.st) converts a
	raw-degrees compass reading (as CLHeadingAgent's trueHeading would report, [0, 360)) into the
	normalized form GRay class >> origin:normalizedBearing: expects. 180 lands on +0.5, not -0.5,
	matching atan2's own (-180, 180] convention (see #asNormalizedBearingRudesheim's comment)."
	self
		assert:	0 asNormalizedBearingRudesheim
		closeTo:	0.0.

	self
		assert:	90 asNormalizedBearingRudesheim
		closeTo:	0.25.

	self
		assert:	180 asNormalizedBearingRudesheim
		closeTo:	0.5.

	self
		assert:	270 asNormalizedBearingRudesheim
		closeTo:	-0.25.
]
