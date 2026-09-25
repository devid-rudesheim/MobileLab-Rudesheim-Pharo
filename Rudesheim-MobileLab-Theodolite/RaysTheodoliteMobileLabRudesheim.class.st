"
A RaysTheodoliteMobileLabRudesheim draws Theodolite's recorded bearing lines as rays on the map
(NocoDB Sections 項番GM), one of the two things dispatched to polymorphically alongside
MarkersTheodoliteMobileLabRudesheim -- `{ Rays renderer: r. Markers renderer: r } do: [ :each |
aCanvas draw: each ]`, via AthensCanvas>>#draw:'s own generic double-dispatch
(`^ anObject drawOnAthensCanvas: self`, provided by Athens itself, not defined here) -- both
answering the same #drawOnAthensCanvas: that convention expects, per this project's 'prefer
polymorphism over switch/if on kind' convention (~/.claude/CLAUDE.md's Design section) as well as
Athens' own. Reached as `Rudesheim MobileLab Theodolite Rays`.

`renderer` (a RendererTheodoliteMobileLabRudesheim, one redraw's shared `lines`/`bounds`/`extent`/
`scale`/#screenPointFor: context) is set once at construction, via the class-side #renderer:
convenience -- it outlives a single #drawOnAthensCanvas: call, unlike `canvas`, which only exists
for the duration of Athens' own paint callback and is passed as a plain argument to
#drawOnAthensCanvas: instead.

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
RaysTheodoliteMobileLabRudesheim class >> renderer: aRendererTheodoliteMobileLabRudesheim [
	^ self new
		renderer:	aRendererTheodoliteMobileLabRudesheim;
		yourself.
]

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

{ #category : 'accessing' }
RaysTheodoliteMobileLabRudesheim >> renderer [
	^ renderer.
]

{ #category : 'accessing' }
RaysTheodoliteMobileLabRudesheim >> renderer: aRendererTheodoliteMobileLabRudesheim [
	renderer := aRendererTheodoliteMobileLabRudesheim assertNotNilRudesheim.
]
