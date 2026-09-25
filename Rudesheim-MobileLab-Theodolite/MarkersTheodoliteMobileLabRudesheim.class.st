"
A MarkersTheodoliteMobileLabRudesheim draws origin/intersection markers on Theodolite's map
(NocoDB Sections 項番GM), one of the two things dispatched to polymorphically alongside
RaysTheodoliteMobileLabRudesheim -- `{ Rays renderer: r. Markers renderer: r } do: [ :each |
aCanvas draw: each ]`, via AthensCanvas>>#draw:'s own generic double-dispatch
(`^ anObject drawOnAthensCanvas: self`, provided by Athens itself, not defined here) -- both
answering the same #drawOnAthensCanvas: that convention expects, per this project's 'prefer
polymorphism over switch/if on kind' convention (~/.claude/CLAUDE.md's Design section) as well as
Athens' own. Reached as `Rudesheim MobileLab Theodolite Markers`.

`renderer` (a RendererTheodoliteMobileLabRudesheim, one redraw's shared `lines`/`bounds`/`extent`/
`scale`/#screenPointFor: context) is set once at construction, via the class-side #renderer:
convenience -- it outlives a single #drawOnAthensCanvas: call, unlike `canvas`, which only exists
for the duration of Athens' own paint callback and is passed as a plain argument to
#drawOnAthensCanvas: instead.

Draws every recorded line's origin in blue and the current intersection point (if any) in red, via
one data-driven pass over `{ points. color }` pairs rather than two near-duplicate loops.
"
Class {
	#name : 'MarkersTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'renderer'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'instance creation' }
MarkersTheodoliteMobileLabRudesheim class >> renderer: aRendererTheodoliteMobileLabRudesheim [
	^ self new
		renderer:	aRendererTheodoliteMobileLabRudesheim;
		yourself.
]

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

{ #category : 'accessing' }
MarkersTheodoliteMobileLabRudesheim >> renderer [
	^ renderer.
]

{ #category : 'accessing' }
MarkersTheodoliteMobileLabRudesheim >> renderer: aRendererTheodoliteMobileLabRudesheim [
	renderer := aRendererTheodoliteMobileLabRudesheim assertNotNilRudesheim.
]
