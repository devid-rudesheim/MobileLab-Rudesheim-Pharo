"
A MarkersTheodoliteMobileLabRudesheimTest draws MarkersTheodoliteMobileLabRudesheim's
#drawOnAthensCanvas: onto a real, in-memory `AthensCairoSurface` (fully headless, same kind of
surface RaysTheodoliteMobileLabRudesheimTest uses) and checks that a recorded line's origin marker
actually lands on it -- the origin is a Geometry `GPoint`, which
RendererTheodoliteMobileLabRudesheim>>#screenPointFor: has to convert before its kernel Point math.
"
Class {
	#name : 'MarkersTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
MarkersTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite Markers.
]

{ #category : 'accessing' }
MarkersTheodoliteMobileLabRudesheimTest >> defaultBasicTarget [
	"TShouldntNewRudesheim blocks #new; #basicTarget (BasicRudesheimTest>>#testBasicInstanceCreation0)
	only needs *a* instance of #targetClass, so a bare #basicNew stands in for #renderer: here."
	^ self targetClass basicNew.
]

{ #category : 'private' }
MarkersTheodoliteMobileLabRudesheimTest >> formAfterDrawing: aBearingLinesTheodoliteMobileLabRudesheim [
	"Draws only this Markers layer (no Rays) for aBearingLinesTheodoliteMobileLabRudesheim onto a
	fresh transparent in-memory surface and answers the result as a Form. Duplicated from
	RaysTheodoliteMobileLabRudesheimTest -- only the layer class under test differs."
	|
		surface
	|

	surface :=
		AthensCairoSurface
			extent:	200 @ 200.

	surface
		drawDuring:
		[ :aCanvas |
			(
				Rudesheim MobileLab Theodolite Renderer
					renderersFor:	aBearingLinesTheodoliteMobileLabRudesheim
					canvas:	aCanvas
			)
				do:
				[ :eachRenderer |
					(
						self targetClass
							renderer:	eachRenderer
					)
						drawOnAthensCanvas:	aCanvas.
				].
		].

	^ surface asForm.
]

{ #category : 'tests' }
MarkersTheodoliteMobileLabRudesheimTest >> testDrawOnAthensCanvasPaintsRecordedOrigin [
	|
		lines
	|

	lines := Rudesheim MobileLab Theodolite BearingLines new.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	self
		deny:
		(
			(
				self
					formAfterDrawing:	lines
			) colorsUsed
				reject:	#isTransparent
		) isEmpty.
]
