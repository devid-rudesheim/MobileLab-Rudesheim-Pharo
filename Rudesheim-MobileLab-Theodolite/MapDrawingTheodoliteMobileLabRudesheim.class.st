"
A MapDrawingTheodoliteMobileLabRudesheim is the stateless class-side utility that renders
Theodolite's self-drawn map (WidgetsTheodoliteMobileLabRudesheim>>#mapArea, an SpAthensPresenter --
decision recorded in NocoDB Sections 項番GM, 2026-09-25) from the current
BearingLinesTheodoliteMobileLabRudesheim. Reached as `Rudesheim MobileLab Theodolite MapDrawing`.
Wired from SpecBuilderTheodoliteMobileLabRudesheim>>#bindModel:toView: as the mapArea's
`drawBlock:`, and re-invoked on every redraw the add/remove/discard action blocks trigger.

Split so the geometry is unit-testable without an actual Athens surface:
- #worldBoundsFor: answers the Rectangle (world coordinates) that must stay fully visible -- every
  recorded line's origin plus the current intersection point, if any (this is exactly the
  requirement: every 'Add line' press must refit the view so all origins and the intersection stay
  in frame). nil when there is nothing to fit yet.
- #scaleToFit:inExtent: and #screenPointFor:bounds:scale:extent: are pure world-to-canvas-pixel
  math (uniform scale with a 15% margin, Y flipped so world north/+y draws upward) -- no Athens
  dependency, so a test can assert exact Points/scales from known inputs.
- #drawBearingLines:extent:on:, #drawRaysOf:bounds:scale:extent:on: and #drawMarker:color:on: are
  the actual Athens canvas calls (untestable headlessly), kept thin by using the geometry above.

Each recorded line is drawn as a ray from its origin far enough to cross the fitted frame (a
multiple of the frame's own diagonal, not a fixed world length, since real GPS-scale coordinates
and GRayTest's synthetic ones differ by orders of magnitude) -- overflow past the presenter's own
bounds is left to ordinary Morphic clipping rather than an explicit #clipBy:during:, per this app's
thin-design convention (NocoDB Sections 項番FM/GM: no machinery beyond what a caller actually
needs).
"
Class {
	#name : 'MapDrawingTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'drawing' }
MapDrawingTheodoliteMobileLabRudesheim class >> drawBearingLines: aLinesBearingLinesTheodoliteMobileLabRudesheim
extent: anExtentPoint
on: aCanvasAthensCanvas [
	|
		bounds
		scale
	|

	aCanvasAthensCanvas surface
		clear.

	bounds :=
		self
			worldBoundsFor:	aLinesBearingLinesTheodoliteMobileLabRudesheim.

	bounds
		ifNil:
		[
			^ self.
		].

	scale :=
		self
			scaleToFit:	bounds
			inExtent:	anExtentPoint.

	self
		drawRaysOf:	aLinesBearingLinesTheodoliteMobileLabRudesheim asArray
		bounds:	bounds
		scale:	scale
		extent:	anExtentPoint
		on:	aCanvasAthensCanvas.

	aLinesBearingLinesTheodoliteMobileLabRudesheim
		do:
		[ :each |
			self
				drawMarker:
				(
					self
						screenPointFor:	each initialPoint
						bounds:	bounds
						scale:	scale
						extent:	anExtentPoint
				)
				color:	Color blue
				on:	aCanvasAthensCanvas.
		].

	aLinesBearingLinesTheodoliteMobileLabRudesheim intersectionPoint
		do:
		[ :each |
			self
				drawMarker:
				(
					self
						screenPointFor:	each
						bounds:	bounds
						scale:	scale
						extent:	anExtentPoint
				)
				color:	Color red
				on:	aCanvasAthensCanvas.
		].
]

{ #category : 'private' }
MapDrawingTheodoliteMobileLabRudesheim class >> drawMarker: aPointPoint
color: aColorColor
on: aCanvasAthensCanvas [
	|
		radius
	|

	radius := 4.

	aCanvasAthensCanvas
		setPaint:	aColorColor.

	aCanvasAthensCanvas
		drawShape:	( aPointPoint - radius corner: aPointPoint + radius ).
]

{ #category : 'private' }
MapDrawingTheodoliteMobileLabRudesheim class >> drawRaysOf: aLinesArray
bounds: aBoundsRectangle
scale: aScaleNumber
extent: anExtentPoint
on: aCanvasAthensCanvas [
	|
		rayLength
	|

	rayLength := ( anExtentPoint x max: anExtentPoint y ) / aScaleNumber * 3.

	aLinesArray
		do:
		[ :each |
			|
				direction
				farPoint
				path
				from
				to
			|

			direction := each directionPoint - each initialPoint.

			direction = ( 0 @ 0 )
				ifFalse:
				[
					farPoint := each initialPoint + ( direction / direction r * rayLength ).

					from :=
						self
							screenPointFor:	each initialPoint
							bounds:	aBoundsRectangle
							scale:	aScaleNumber
							extent:	anExtentPoint.

					to :=
						self
							screenPointFor:	farPoint
							bounds:	aBoundsRectangle
							scale:	aScaleNumber
							extent:	anExtentPoint.

					path :=
						aCanvasAthensCanvas
							createPath:
							[ :aBuilder |
								aBuilder
									absolute;
									moveTo:	from;
									lineTo:	to.
							].

					(
						aCanvasAthensCanvas
							setStrokePaint:	Color gray
					)
						width:	1.

					aCanvasAthensCanvas
						drawShape:	path.
				].
		].
]

{ #category : 'geometry' }
MapDrawingTheodoliteMobileLabRudesheim class >> scaleToFit: aBoundsRectangle
inExtent: anExtentPoint [
	"Uniform world-units-to-pixels scale that fits aBoundsRectangle inside anExtentPoint with a
	15% margin, preserving aspect ratio."
	^
	(
		( anExtentPoint x / aBoundsRectangle width )
			min:	( anExtentPoint y / aBoundsRectangle height )
	)
		* 0.85.
]

{ #category : 'geometry' }
MapDrawingTheodoliteMobileLabRudesheim class >> screenPointFor: aPointPoint
bounds: aBoundsRectangle
scale: aScaleNumber
extent: anExtentPoint [
	"World point -> canvas pixel point: aBoundsRectangle's center maps to anExtentPoint's center,
	scaled by aScaleNumber, with Y flipped so world north (+y) draws upward."
	|
		worldCenter
		canvasCenter
	|

	worldCenter := aBoundsRectangle center.
	canvasCenter := anExtentPoint / 2.

	^
	(
		( aPointPoint x - worldCenter x ) * aScaleNumber + canvasCenter x
	)
		@
		(
			canvasCenter y - ( ( aPointPoint y - worldCenter y ) * aScaleNumber )
		).
]

{ #category : 'geometry' }
MapDrawingTheodoliteMobileLabRudesheim class >> worldBoundsFor: aBearingLinesTheodoliteMobileLabRudesheim [
	"Rectangle enclosing every recorded line's origin plus the current intersection point (if
	any) -- the set of points that must stay fully visible after every 'Add line' press. nil when
	there is nothing to fit (no lines recorded yet). A degenerate (zero-area) box -- one point, or
	several exactly-coincident points -- is padded to a minimum span so a scale can always be
	computed from it."
	|
		points
		minX
		maxX
		minY
		maxY
	|

	points :=
		(
			aBearingLinesTheodoliteMobileLabRudesheim asArray
				collect:
				[ :each |
					each initialPoint.
				]
		)
			,	aBearingLinesTheodoliteMobileLabRudesheim intersectionPoint.

	points isEmpty
		ifTrue:
		[
			^ nil.
		].

	minX :=
		(
			points
				collect:
				[ :each |
					each x.
				]
		)
			min.
	maxX :=
		(
			points
				collect:
				[ :each |
					each x.
				]
		)
			max.
	minY :=
		(
			points
				collect:
				[ :each |
					each y.
				]
		)
			min.
	maxY :=
		(
			points
				collect:
				[ :each |
					each y.
				]
		)
			max.

	( maxX - minX ) < 0.0001
		ifTrue:
		[
			minX := minX - 0.0005.
			maxX := maxX + 0.0005.
		].
	( maxY - minY ) < 0.0001
		ifTrue:
		[
			minY := minY - 0.0005.
			maxY := maxY + 0.0005.
		].

	^ ( minX @ minY )
		corner:	( maxX @ maxY ).
]
