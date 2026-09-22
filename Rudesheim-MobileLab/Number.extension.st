Extension { #name : 'Number' }

{ #category : '*Rudesheim-MobileLab' }
Number >> asNormalizedBearingRudesheim [
	"self is a compass bearing in raw degrees, [0, 360) -- the form a real sensor reading (e.g.
	CLHeadingAgent's trueHeading) arrives in. Converts to Rudesheim-MobileLab's normalized bearing
	form, (-0.5, 0.5] (see GRay class >> origin:normalizedBearing:'s comment): degrees at or below
	180 scale straight through; degrees above 180 wrap into negative territory instead of
	continuing past 0.5, matching atan2's own (-180, 180] convention (180 itself lands on +0.5, not
	-0.5)."
	self > 180
		ifTrue:
		[
			^ ( ( self - 360 ) ) / 360.
		].

	^ self / 360.
]
