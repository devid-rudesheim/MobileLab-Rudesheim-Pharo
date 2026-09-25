"
A CoordinateParserLocationMobileLabRudesheim parses the human-readable text `CLLocation>>-description`
produces (e.g. '<+35.68123600,+139.76712500> +/- 0.00m (speed -1.00 mps / course -1.00) @ ...') into
a GPoint -- see MacOSLocationRudesheim's comment for why this text form is used instead of reading
`-coordinate` (a `CLLocationCoordinate2D` struct) directly through the ObjC bridge. Reached as
`Rudesheim MobileLab Location CoordinateParser`.

The description's own `<latitude,longitude>` order is swapped on the way into the GPoint, to match
this project's `longitude@latitude` convention (see GRay class >> origin:normalizedBearing:'s
comment).
"
Class {
	#name : 'CoordinateParserLocationMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'parsing' }
CoordinateParserLocationMobileLabRudesheim class >> parseCLLocationDescription: aString [
	|
		stream
		latitudeString
		longitudeString
	|

	stream := aString readStream.

	stream
		upTo:	$<.

	latitudeString :=
		stream
			upTo:	$,.

	longitudeString :=
		stream
			upTo:	$>.

	^
	(
		self
			signedNumberFrom:	longitudeString
	) ,
	(
		self
			signedNumberFrom:	latitudeString
	).
]

{ #category : 'private' }
CoordinateParserLocationMobileLabRudesheim class >> signedNumberFrom: aNumberString [
	|
		digits
	|

	digits := aNumberString.

	$+ = aNumberString first
		ifTrue:
		[
			digits := aNumberString allButFirst.
		].

	^ digits asNumber.
]
