"
An OSLocationRudesheim is the default/base OS-specific implementation for reading the device's
current position and true-heading direction, reached as `Smalltalk os rudesheim location` (or, for
reflective discovery, `Rudesheim OS location`) -- mirroring OSRudesheim's own dispatch pattern (see
e.g. its `Mac`/`openCL`/`tableQuery` accessors, Rudesheim-Kernel).

Concrete platforms only need to override the two primitives, #currentLocation (a GPoint) and
#currentNormalizedBearing (Rudesheim-MobileLab's normalized bearing form, see GRay class >>
origin:normalizedBearing:'s comment) -- see MacOSLocationRudesheim. #currentRay is a template
method defined once here, combining whatever the two primitives answer into a single GRay; it does
not need its own per-platform override. This default's two primitives have no real implementation,
so they signal #subclassResponsibility (which #currentRay then surfaces too, since it calls them).
"
Class {
	#name : 'OSLocationRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'accessing' }
OSLocationRudesheim class >> currentLocation [
	^ self subclassResponsibility.
]

{ #category : 'accessing' }
OSLocationRudesheim class >> currentNormalizedBearing [
	^ self subclassResponsibility.
]

{ #category : 'accessing' }
OSLocationRudesheim class >> currentRay [
	^ GRay
		origin:	self currentLocation
		normalizedBearing:	self currentNormalizedBearing.
]
