"
A RaysTheodoliteMobileLabRudesheim draws Theodolite's recorded bearing lines as rays on the map
(NocoDB Sections 項番GM), one of the two LayerTheodoliteMobileLabRudesheim subclasses dispatched to
polymorphically alongside MarkersTheodoliteMobileLabRudesheim -- see that base class's comment for
`renderer`/#drawOnAthensCanvas:'s shared shape. Reached as `Rudesheim MobileLab Theodolite Rays`.

Each recorded line is drawn as a ray from its origin far enough to cross the fitted frame (a
multiple of the frame's own diagonal, not a fixed world length, since real GPS-scale coordinates
and GRayTest's synthetic ones differ by orders of magnitude) -- overflow past the presenter's own
bounds is left to ordinary Morphic clipping rather than an explicit #clipBy:during:, per this app's
thin-design convention (NocoDB Sections 項番FM/GM).
"
Class {
	#name : 'RaysTheodoliteMobileLabRudesheim',
	#superclass : 'LayerTheodoliteMobileLabRudesheim',
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'drawing' }
RaysTheodoliteMobileLabRudesheim >> drawOnAthensCanvas: anAthensCanvas [
	|
		rayLength
	|

	rayLength :=
	(
		self renderer extent x
			max:	self renderer extent y
	) / self renderer scale * 3.

	self renderer lines asArray
		do:
		[ :each |
			|
				direction
				farPoint
				screenPoints
				path
			|

			direction := each directionPoint - each initialPoint.

			direction = ( 0 @ 0 )
				ifFalse:
				[
					farPoint := each initialPoint + ( direction / direction r * rayLength ).

					screenPoints :=
					{
						each initialPoint.
						farPoint
					}
						collect:
						[ :point |
							self renderer
								screenPointFor:	point.
						].

					path :=
						anAthensCanvas
							createPath:
							[ :aBuilder |
								aBuilder
									absolute;
									moveTo:	screenPoints first;
									lineTo:	screenPoints last.
							].

					(
						anAthensCanvas
							setStrokePaint:	Color gray
					)
						width:	1.

					anAthensCanvas
						drawShape:	path.
				].
		].
]
