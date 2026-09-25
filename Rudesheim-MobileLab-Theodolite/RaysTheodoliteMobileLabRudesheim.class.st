"
A RaysTheodoliteMobileLabRudesheim draws Theodolite's recorded bearing lines as rays on the map
(NocoDB Sections 項番GM), one of the two things dispatched to polymorphically alongside
MarkersTheodoliteMobileLabRudesheim -- `{ Rays. Markers } do: [ :each | each drawOn: renderer ]` --
both answering the same class-side #drawOn:, per this project's 'prefer polymorphism over
switch/if on kind' convention (~/.claude/CLAUDE.md's Design section), rather than being two named
methods on one class. Reached as `Rudesheim MobileLab Theodolite Rays`.

Stateless: #drawOn: never references self, so it stays a class-side method
(~/.claude/CLAUDE.md's 'put self-free logic on the class side' rule) taking `aRenderer` (a
MapDrawingTheodoliteMobileLabRudesheim, one redraw's shared `lines`/`canvas`/`screenPointFor:`
context) as a plain argument rather than holding it as instance state.

Each recorded line is drawn as a ray from its origin far enough to cross the fitted frame (a
multiple of the frame's own diagonal, not a fixed world length, since real GPS-scale coordinates
and GRayTest's synthetic ones differ by orders of magnitude) -- overflow past the presenter's own
bounds is left to ordinary Morphic clipping rather than an explicit #clipBy:during:, per this app's
thin-design convention (NocoDB Sections 項番FM/GM).
"
Class {
	#name : 'RaysTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'drawing' }
RaysTheodoliteMobileLabRudesheim class >> drawOn: aRenderer [
	|
		rayLength
	|

	rayLength :=
	(
		aRenderer extent x
			max:	aRenderer extent y
	) / aRenderer scale * 3.

	aRenderer lines asArray
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
							aRenderer
								screenPointFor:	point.
						].

					path :=
						aRenderer canvas
							createPath:
							[ :aBuilder |
								aBuilder
									absolute;
									moveTo:	screenPoints first;
									lineTo:	screenPoints last.
							].

					(
						aRenderer canvas
							setStrokePaint:	Color gray
					)
						width:	1.

					aRenderer canvas
						drawShape:	path.
				].
		].
]
