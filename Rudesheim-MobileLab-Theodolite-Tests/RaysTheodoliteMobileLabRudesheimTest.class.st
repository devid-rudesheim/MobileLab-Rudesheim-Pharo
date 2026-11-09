"
A RaysTheodoliteMobileLabRudesheimTest draws RaysTheodoliteMobileLabRudesheim's #drawOnAthensCanvas:
onto a real, in-memory `AthensCairoSurface` (fully headless, same kind of surface
RendererTheodoliteMobileLabRudesheimTest already uses for #renderersFor:canvas:) and checks what
actually landed on it -- the ray's direction is a Geometry `GVector`, whose length is #length (it
has no #r, unlike kernel Point), and a ray whose direction point equals its origin (a degenerate
`GZeroVector` direction) has no direction to draw at all.
"
Class {
	#name : 'RaysTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
RaysTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite Rays.
]

{ #category : 'accessing' }
RaysTheodoliteMobileLabRudesheimTest >> defaultBasicTarget [
	"TShouldntNewRudesheim blocks #new; #basicTarget (BasicRudesheimTest>>#testBasicInstanceCreation0)
	only needs *a* instance of #targetClass, so a bare #basicNew stands in for #renderer: here."
	^ self targetClass basicNew.
]

{ #category : 'private' }
RaysTheodoliteMobileLabRudesheimTest >> formAfterDrawing: aBearingLinesTheodoliteMobileLabRudesheim [
	"Draws only this Rays layer (no Markers) for aBearingLinesTheodoliteMobileLabRudesheim onto a
	fresh transparent in-memory surface and answers the result as a Form."
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
RaysTheodoliteMobileLabRudesheimTest >> testDrawOnAthensCanvasSkipsZeroLengthRay [
	|
		lines
	|

	lines := Rudesheim MobileLab Theodolite BearingLines new.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				direction:	0 , 0
		).

	self
		assert:
		(
			(
				self
					formAfterDrawing:	lines
			) colorsUsed
				reject:	#isTransparent
		) isEmpty.
]

{ #category : 'tests' }
RaysTheodoliteMobileLabRudesheimTest >> testDrawOnAthensCanvasStrokesRecordedRay [
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
