Extension { #name : 'GRay' }

{ #category : '*Rudesheim-MobileLab' }
GRay class >> origin: aGPoint
normalizedBearing: aNumber [
	"aNumber is a compass bearing normalized to (-0.5, 0.5] -- 0.0=north, positive=clockwise, a full
	turn is 1.0 (so east=0.25, south=0.5, west=-0.25); every internal Rudesheim-MobileLab
	representation of an angle is normalized this way, never raw degrees (see
	Rudesheim Utility Normalizer Angle Degree's comment for the forward conversion, used at the one
	place a raw sensor reading like CLHeading's trueHeading enters the system, via
	MacOSLocationRudesheim). On the
	origin+longitude@latitude plane that is dx=sin(bearing), dy=cos(bearing); #origin:direction:
	wants a point on the ray, not a bare vector, so we offset origin by the unit vector. Multiplying
	back out to degrees never needs the sign-wrap correction the forward conversion does -- #sin/#cos
	are periodic, so e.g. -90 degrees and 270 degrees agree."
	|
		angle
	|

	angle :=
	(
		Rudesheim Utility Normalizer Angle Degree
			denormalizeAngle:	aNumber
	) degrees.

	^ self
		origin:	aGPoint
		direction:	aGPoint + ( angle sin , angle cos ).
]
