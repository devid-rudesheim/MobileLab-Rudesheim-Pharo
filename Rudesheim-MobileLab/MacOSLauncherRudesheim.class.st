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
	| lib workspace url |
	lib := ObjCLibrary uniqueInstance.
	workspace := lib
		sendMessage:	(lib lookupSelector: 'sharedWorkspace')
		to:	(lib lookupClass: 'NSWorkspace').
	url := lib
		sendMessage:	(lib lookupSelector: 'URLWithString:')
		to:	(lib lookupClass: 'NSURL')
		with:	(lib nsStringOf: aZnUrl displayString).

	^ lib
		sendMessage:	(lib lookupSelector: 'openURL:')
		to:	workspace
		with:	url.
]
