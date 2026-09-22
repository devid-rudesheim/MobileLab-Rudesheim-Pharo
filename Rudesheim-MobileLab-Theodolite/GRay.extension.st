Extension { #name : 'GRay' }

{ #category : '*Rudesheim-MobileLab-Theodolite' }
GRay class >> origin: aGPoint bearing: aNumber [
	"aNumber is a compass bearing in degrees (0=north, clockwise). On the origin+longitude@latitude
	plane that is dx=sin(bearing), dy=cos(bearing); #origin:direction: wants a point on the ray, not
	a bare vector, so we offset origin by the unit vector."
	|
		angle
	|

	angle := aNumber degrees.

	^ self
		origin:	aGPoint
		direction:	aGPoint + ( angle sin , angle cos ).
]