"
A MacOSLauncherRudesheim is the macOS-specific OSLauncherRudesheim override, reached as
`Smalltalk os rudesheim launcher` while running on macOS. Opens a URL through AppKit's
`NSWorkspace>>-openURL:`, over the same `ObjCLibrary`-based ObjC bridge MacOSLocationRudesheim uses
(see note/pharo-ops.md section 40). Unlike CoreLocation (see MacOSLocationRudesheim's comment),
AppKit is already linked into the Pharo process, so no `DynamicLoader` framework load is needed
here, and opening a URL this way needs no CoreLocation-style permission dialog.
"
Class {
	#name : 'MacOSLauncherRudesheim',
	#superclass : 'OSLauncherRudesheim',
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'accessing' }
MacOSLauncherRudesheim class >> open: aZnUrl [
	|
		library
		workspace
		url
	|

	library := ObjCLibrary uniqueInstance.

	workspace :=
		library
			sendMessage:
			(
				library
					lookupSelector:	'sharedWorkspace'
			)
			to:
			(
				library
					lookupClass:	'NSWorkspace'
			).

	url :=
		library
			sendMessage:
			(
				library
					lookupSelector:	'URLWithString:'
			)
			to:
			(
				library
					lookupClass:	'NSURL'
			)
			with:
			(
				library
					nsStringOf:	aZnUrl displayString
			).

	^ library
		sendMessage:
		(
			library
				lookupSelector:	'openURL:'
		)
		to:	workspace
		with:	url.
]
