"
A MacOSLocationRudesheim is the macOS-specific OSLocationRudesheim override, reached as
`Smalltalk os rudesheim location` while running on macOS. Overrides the two primitives
OSLocationRudesheim's #currentRay template method needs: #currentLocation (the device's current
position, via `CLLocationManagerAgent` over the ObjC bridge, see note/pharo-ops.md section 40/41)
and #currentNormalizedBearing (the device's current true-heading direction, via `CLHeadingAgent`,
converted from raw degrees to Rudesheim-MobileLab's normalized bearing form through
`Rudesheim Utility Normalizer Angle Degree normalizeAngle:` -- this is the one boundary where a
raw-degrees sensor reading enters the system).

`CLLocationManagerAgent`/`CLHeadingAgent` are deliberately not implemented yet -- that is separate,
iOS-only, unverified-headless work (see note/ios-triangulation-app.md section 8 item 4). Referencing
them here compiles fine (they resolve once that work lands) but neither primitive, nor #currentRay
built from them, can actually run until then.
"
Class {
	#name : 'MacOSLocationRudesheim',
	#superclass : 'OSLocationRudesheim',
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'accessing' }
MacOSLocationRudesheim class >> currentLocation [
	^ CLLocationManagerAgent default currentLocation.
]

{ #category : 'accessing' }
MacOSLocationRudesheim class >> currentNormalizedBearing [
	^ Rudesheim Utility Normalizer Angle Degree normalizeAngle: CLHeadingAgent default trueHeading.
]
