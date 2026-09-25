"
A RaysTheodoliteMobileLabRudesheim draws Theodolite's recorded bearing lines as rays on the map
(NocoDB Sections 項番GM), one of the two things #draw's polymorphic `{ Rays renderer: self.
Markers renderer: self } do: [ :each | each draw ]` dispatches to alongside
MarkersTheodoliteMobileLabRudesheim -- both answer the same #draw protocol, per this project's
'prefer polymorphism over switch/if on kind' convention (~/.claude/CLAUDE.md's Design section),
rather than being two named methods on one class. Reached as `Rudesheim MobileLab Theodolite
Rays`.

Holds no geometry of its own: `renderer` (a MapDrawingTheodoliteMobileLabRudesheim, set once via
the class-side #renderer: convenience) is the single source of `lines`/`canvas`/`screenPointFor:`,
so #draw reads `self renderer lines`/`self renderer canvas` etc. rather than duplicating any of
that state.

Each recorded line is drawn as a ray from its origin far enough to cross the fitted frame (a
multiple of the frame's own diagonal, not a fixed world length, since real GPS-scale coordinates
and GRayTest's synthetic ones differ by orders of magnitude) -- overflow past the presenter's own
bounds is left to ordinary Morphic clipping rather than an explicit #clipBy:during:, per this app's
thin-design convention (NocoDB Sections 項番FM/GM).
"
Class {
	#name : 'RaysTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'renderer'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'instance creation' }
RaysTheodoliteMobileLabRudesheim class >> renderer: aMapDrawingTheodoliteMobileLabRudesheim [
	^ self new
		renderer:	aMapDrawingTheodoliteMobileLabRudesheim;
		yourself.
]

{ #category : 'drawing' }
RaysTheodoliteMobileLabRudesheim >> draw [
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
						self renderer canvas
							createPath:
							[ :aBuilder |
								aBuilder
									absolute;
									moveTo:	screenPoints first;
									lineTo:	screenPoints last.
							].

					(
						self renderer canvas
							setStrokePaint:	Color gray
					)
						width:	1.

					self renderer canvas
						drawShape:	path.
				].
		].
]

{ #category : 'accessing' }
RaysTheodoliteMobileLabRudesheim >> renderer [
	^ renderer.
]

{ #category : 'accessing' }
RaysTheodoliteMobileLabRudesheim >> renderer: aMapDrawingTheodoliteMobileLabRudesheim [
	renderer := aMapDrawingTheodoliteMobileLabRudesheim assertNotNilRudesheim.
]
