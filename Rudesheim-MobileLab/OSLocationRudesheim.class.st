"
An OSLocationRudesheim is the default/base OS-specific implementation for reading the device's
current position and true-heading direction as a single GRay, reached as
`Smalltalk os rudesheim location` (or, for reflective discovery, `Rudesheim OS location`) --
mirroring OSRudesheim's own dispatch pattern (see e.g. its `Mac`/`openCL`/`tableQuery` accessors,
Rudesheim-Kernel). Concrete platforms override the class-side #currentRay with a real
implementation (see MacOSLocationRudesheim); this default has none, so it signals
#subclassResponsibility.
"
Class {
	#name : 'OSLocationRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'accessing' }
OSLocationRudesheim class >> currentRay [
	^ self subclassResponsibility.
]
