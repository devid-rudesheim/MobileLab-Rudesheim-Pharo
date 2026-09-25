"
A MarkersTheodoliteMobileLabRudesheim draws origin/intersection markers on Theodolite's map
(NocoDB Sections 項番GM), one of the two LayerTheodoliteMobileLabRudesheim subclasses dispatched to
polymorphically alongside RaysTheodoliteMobileLabRudesheim -- see that base class's comment for
`renderer`/#drawOnAthensCanvas:'s shared shape. Reached as `Rudesheim MobileLab Theodolite
Markers`.

Draws every recorded line's origin in blue and the current intersection point (if any) in red, via
one data-driven pass over `{ points. color }` pairs rather than two near-duplicate loops.
"
Class {
	#name : 'MarkersTheodoliteMobileLabRudesheim',
	#superclass : 'LayerTheodoliteMobileLabRudesheim',
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'drawing' }
MarkersTheodoliteMobileLabRudesheim >> drawOnAthensCanvas: anAthensCanvas [
	|
		radius
	|

	radius := 4.

	{
		{
			self renderer lines asArray
				collect:	#initialPoint.
			Color blue
		}.
		{
			self renderer lines intersectionPoint.
			Color red
		}
	}
		do:
		[ :pair |
			pair first
				do:
				[ :each |
					|
						screenPoint
					|

					screenPoint :=
						self renderer
							screenPointFor:	each.

					anAthensCanvas
						setPaint:	pair last.

					anAthensCanvas
						drawShape:
						(
							screenPoint - radius
								corner:	screenPoint + radius
						).
				].
		].
]
