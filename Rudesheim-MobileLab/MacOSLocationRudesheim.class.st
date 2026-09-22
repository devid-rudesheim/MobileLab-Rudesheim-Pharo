"
A MacOSLocationRudesheim is the macOS-specific OSLocationRudesheim override, reached as
`Smalltalk os rudesheim location` while running on macOS. #currentRay reads the device's current
position (`CLLocationManagerAgent`) and true-heading direction (`CLHeadingAgent`) over the ObjC
bridge (see note/pharo-ops.md section 40/41), converts the heading's raw degrees to
Rudesheim-MobileLab's normalized bearing form (`Number>>#asNormalizedBearingRudesheim` -- this is
the one boundary where a raw-degrees sensor reading enters the system), and combines them into a
single GRay via `GRay class >> origin:normalizedBearing:` (Rudesheim-MobileLab's own
GRay.extension.st).

`CLLocationManagerAgent`/`CLHeadingAgent` are deliberately not implemented yet -- that is separate,
iOS-only, unverified-headless work (see note/ios-triangulation-app.md section 8 item 4). Referencing
them here compiles fine (they resolve once that work lands) but #currentRay cannot actually run
until then.
"
Class {
	#name : 'MacOSLocationRudesheim',
	#superclass : 'OSLocationRudesheim',
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'accessing' }
MacOSLocationRudesheim class >> currentRay [
	^ GRay
		origin:	CLLocationManagerAgent default currentLocation
		normalizedBearing:	CLHeadingAgent default trueHeading asNormalizedBearingRudesheim.
]
