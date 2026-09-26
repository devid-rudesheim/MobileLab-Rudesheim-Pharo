"
A LocationUnavailableMobileLabRudesheim is signaled by an OSLocationRudesheim subclass (currently
only MacOSLocationRudesheim>>#signalLocationUnavailable) when the OS never delivers a location/
heading fix -- a known external-cause condition (e.g. macOS never granting CoreLocation
authorization to a bare headless Pharo process, see MacOSLocationRudesheim's own comment), not a
bug in this app. Dedicated so a UI action block can `on:do:` it specifically and show the user a
message instead of dropping into the debugger, without also swallowing unrelated Errors.
"
Class {
	#name : 'LocationUnavailableMobileLabRudesheim',
	#superclass : 'Error',
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'accessing' }
LocationUnavailableMobileLabRudesheim >> messageText [
	^ 'CoreLocation authorization was not granted -- macOS only shows the permission dialog to a process running from a proper .app bundle with an Info.plist NSLocationWhenInUseUsageDescription entry, which this headless Pharo process is not (see note/pharo-ops.md section 41).'.
]
