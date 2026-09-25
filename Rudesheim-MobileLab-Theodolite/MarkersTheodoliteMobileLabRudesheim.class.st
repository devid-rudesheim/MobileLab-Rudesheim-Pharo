"
A MarkersTheodoliteMobileLabRudesheim draws origin/intersection markers on Theodolite's map
(NocoDB Sections 項番GM), one of the two things #draw's polymorphic `{ Rays renderer: self.
Markers renderer: self } do: [ :each | each draw ]` dispatches to alongside
RaysTheodoliteMobileLabRudesheim -- both answer the same #draw protocol, per this project's
'prefer polymorphism over switch/if on kind' convention (~/.claude/CLAUDE.md's Design section),
rather than being two named methods on one class. Reached as `Rudesheim MobileLab Theodolite
Markers`.

Holds no geometry of its own: `renderer` (a MapDrawingTheodoliteMobileLabRudesheim, set once via
the class-side #renderer: convenience) is the single source of `lines`/`canvas`/`screenPointFor:`,
so #draw reads `self renderer lines`/`self renderer canvas` etc. rather than duplicating any of
that state. Draws every recorded line's origin in blue and the current intersection point (if any)
in red, via one data-driven pass over `{ points. color }` pairs rather than two near-duplicate
loops.
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
MarkersTheodoliteMobileLabRudesheim class >> renderer: aMapDrawingTheodoliteMobileLabRudesheim [
	^ self new
		renderer:	aMapDrawingTheodoliteMobileLabRudesheim;
		yourself.
]

{ #category : 'drawing' }
MarkersTheodoliteMobileLabRudesheim >> draw [
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
					self
						drawMarker:
						(
							self renderer
								screenPointFor:	each
						)
						color:	pair last.
				].
		].
]

{ #category : 'private' }
MarkersTheodoliteMobileLabRudesheim >> drawMarker: aPointPoint
color: aColorColor [
	|
		radius
	|

	radius := 4.

	self renderer canvas
		setPaint:	aColorColor.

	self renderer canvas
		drawShape:
		(
			aPointPoint - radius
				corner:	aPointPoint + radius
		).
]

{ #category : 'accessing' }
MarkersTheodoliteMobileLabRudesheim >> renderer [
	^ renderer.
]

{ #category : 'accessing' }
MarkersTheodoliteMobileLabRudesheim >> renderer: aMapDrawingTheodoliteMobileLabRudesheim [
	renderer := aMapDrawingTheodoliteMobileLabRudesheim assertNotNilRudesheim.
]
