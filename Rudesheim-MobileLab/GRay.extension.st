Extension { #name : 'GRay' }

{ #category : '*Rudesheim-MobileLab' }
GRay class >> origin: aGPoint
normalizedBearing: aNumber [
	"aNumber is a compass bearing normalized to (-0.5, 0.5] -- 0.0=north, positive=clockwise, a full
	turn is 1.0 (so east=0.25, south=0.5, west=-0.25); every internal Rudesheim-MobileLab
	representation of an angle is normalized this way, never raw degrees (see Number>>
	#asNormalizedBearingRudesheim for the forward conversion, used at the one place a raw sensor
	reading like CLHeadingAgent's trueHeading enters the system). On the
	origin+longitude@latitude plane that is dx=sin(bearing), dy=cos(bearing); #origin:direction:
	wants a point on the ray, not a bare vector, so we offset origin by the unit vector. Multiplying
	back out to degrees (aNumber * 360) never needs the sign-wrap correction the forward conversion
	does -- #sin/#cos are periodic, so e.g. -90 degrees and 270 degrees agree."
	|
		angle
	|

	angle := ( aNumber * 360 ) degrees.

	^ self
		origin:	aGPoint
		direction:	aGPoint + ( angle sin , angle cos ).
]
