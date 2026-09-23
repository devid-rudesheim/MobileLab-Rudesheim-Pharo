"
An OSLauncherRudesheim is the default/base OS-specific implementation for opening a URL in
whatever the platform's own system handler is (e.g. Maps.app for a maps: URL, the default browser
for an http(s): URL), reached as `Smalltalk os rudesheim launcher` (or, for reflective discovery,
`Rudesheim OS launcher`) -- mirroring OSRudesheim's own dispatch pattern (see e.g. its `location`/
`openCL`/`tableQuery` accessors). This default has no real implementation, so #open: signals
#subclassResponsibility -- see MacOSLauncherRudesheim.
"
Class {
	#name : 'OSLauncherRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'accessing' }
OSLauncherRudesheim class >> open: aZnUrl [
	^ self subclassResponsibility.
]
