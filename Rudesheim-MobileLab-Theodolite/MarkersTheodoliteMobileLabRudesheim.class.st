"
A MarkersTheodoliteMobileLabRudesheim draws origin/intersection markers on Theodolite's map
(NocoDB Sections 項番GM), one of the two things dispatched to polymorphically alongside
RaysTheodoliteMobileLabRudesheim -- `{ Rays. Markers } do: [ :each | each drawOn: renderer ]` --
both answering the same class-side #drawOn:, per this project's 'prefer polymorphism over
switch/if on kind' convention (~/.claude/CLAUDE.md's Design section), rather than being two named
methods on one class. Reached as `Rudesheim MobileLab Theodolite Markers`.

Stateless: #drawOn: never references self, so it stays a class-side method
(~/.claude/CLAUDE.md's 'put self-free logic on the class side' rule) taking `aRenderer` (a
MapDrawingTheodoliteMobileLabRudesheim, one redraw's shared `lines`/`canvas`/`screenPointFor:`
context) as a plain argument rather than holding it as instance state.

Draws every recorded line's origin in blue and the current intersection point (if any) in red, via
one data-driven pass over `{ points. color }` pairs rather than two near-duplicate loops.
"
Class {
	#name : 'MarkersTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'drawing' }
MarkersTheodoliteMobileLabRudesheim class >> drawMarker: aPointPoint
color: aColorColor
on: aRendererMapDrawingTheodoliteMobileLabRudesheim [
	|
		radius
	|

	radius := 4.

	aRendererMapDrawingTheodoliteMobileLabRudesheim canvas
		setPaint:	aColorColor.

	aRendererMapDrawingTheodoliteMobileLabRudesheim canvas
		drawShape:
		(
			aPointPoint - radius
				corner:	aPointPoint + radius
		).
]

{ #category : 'drawing' }
MarkersTheodoliteMobileLabRudesheim class >> drawOn: aRenderer [
	{
		{
			aRenderer lines asArray
				collect:	#initialPoint.
			Color blue
		}.
		{
			aRenderer lines intersectionPoint.
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
							aRenderer
								screenPointFor:	each
						)
						color:	pair last
						on:	aRenderer.
				].
		].
]
