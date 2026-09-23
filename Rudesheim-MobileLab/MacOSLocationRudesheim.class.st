"
A MacOSLocationRudesheim is the macOS-specific OSLocationRudesheim override, reached as
`Smalltalk os rudesheim location` while running on macOS. Overrides the two primitives
OSLocationRudesheim's #currentRay template method needs: #currentLocation (the device's current
position, as a GPoint) and #currentNormalizedBearing (the device's current true-heading direction,
converted from raw degrees to Rudesheim-MobileLab's normalized bearing form through
`Rudesheim Utility Normalizer Angle Degree normalizeAngle:`).

Both go through CoreLocation via the ObjC bridge (`ObjCLibrary`, see note/pharo-ops.md section 40),
using `CLLocationManager`'s delegate-callback API (`requestLocation`/`startUpdatingHeading`,
delivering results to a dynamically-generated NSObject subclass registered as the manager's
delegate -- see note/pharo-ops.md section 41 for the underlying delegate-creation technique this
follows). All ObjC/CoreLocation plumbing is confined to this class's own class-side methods and
class-instance variables (`locationManager`/`locationDelegate`/`delegateCallbacks`/
`pendingLocationDescription`/`pendingHeadingDegrees`) rather than a separate globally-named bridge
class.

`CLLocationCoordinate2D` (the struct `-coordinate` returns) can't be read through
`ObjCLibrary>>#sendMessage:to:` (it treats every return as a bare pointer, and a 2-double struct
uses a different register-based ABI) -- worked around by parsing `CLLocation>>-description`'s
human-readable text form instead, via `Rudesheim MobileLab Location CoordinateParser` (see its own
comment). `trueHeading` (a plain `double` property, no struct-packing issue) is read directly
through `ObjCLibrary>>#sendDoubleMessage:to:`, a small extension added in `ObjCLibrary.extension.st`
specifically to declare that one method's `double`-typed FFI return, unlike the library's own
generic pointer-returning `sendMessage:to:`.

**Known limitation, not a bug here**: macOS only shows CoreLocation's permission dialog to a
process running from a proper `.app` bundle with an `Info.plist`
`NSLocationWhenInUseUsageDescription` entry -- a bare headless `Pharo` binary invocation (as used
by `tool/eval.sh` and every worker image in this project) never gets authorized, so
`authorizationStatus` stays `kCLAuthorizationStatusNotDetermined` forever and neither delegate
callback this class registers for ever actually fires. #currentLocation/#currentNormalizedBearing
therefore always time out and raise (see #signalLocationUnavailable) until this app is packaged as
a real `.app` bundle -- verified 2026-09-12, see note/pharo-ops.md section 41.
"
Class {
	#name : 'MacOSLocationRudesheim',
	#superclass : 'OSLocationRudesheim',
	#classInstVars : [
		'locationManager',
		'locationDelegate',
		'delegateCallbacks',
		'pendingLocationDescription',
		'pendingHeadingDegrees'
	],
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'accessing' }
MacOSLocationRudesheim class >> currentLocation [
	| lib |
	lib := ObjCLibrary uniqueInstance.
	pendingLocationDescription := nil.

	lib
		sendMessage:	(lib lookupSelector: 'requestLocation')
		to:	self locationManager.

	self
		waitUntil:	[ pendingLocationDescription notNil ]
		timeoutSeconds:	25.

	( pendingLocationDescription isNil or: [ pendingLocationDescription isEmpty ] )
		ifTrue:	[ ^ self signalLocationUnavailable ].

	^ Rudesheim MobileLab Location CoordinateParser
		parseCLLocationDescription:	pendingLocationDescription.
]

{ #category : 'accessing' }
MacOSLocationRudesheim class >> currentNormalizedBearing [
	| lib |
	lib := ObjCLibrary uniqueInstance.
	pendingHeadingDegrees := nil.

	lib
		sendMessage:	(lib lookupSelector: 'startUpdatingHeading')
		to:	self locationManager.

	self
		waitUntil:	[ pendingHeadingDegrees notNil ]
		timeoutSeconds:	25.

	lib
		sendMessage:	(lib lookupSelector: 'stopUpdatingHeading')
		to:	self locationManager.

	pendingHeadingDegrees ifNil: [ ^ self signalLocationUnavailable ].

	^ Rudesheim Utility Normalizer Angle Degree normalizeAngle: pendingHeadingDegrees.
]

{ #category : 'private' }
MacOSLocationRudesheim class >> locationManager [
	^ locationManager ifNil: [ locationManager := self defaultLocationManager ].
]

{ #category : 'private' }
MacOSLocationRudesheim class >> defaultLocationManager [
	| lib manager |
	lib := ObjCLibrary uniqueInstance.

	manager := lib sendMessage: (lib lookupSelector: 'alloc') to: (lib lookupClass: 'CLLocationManager').
	manager := lib sendMessage: (lib lookupSelector: 'init') to: manager.

	lib
		sendMessage:	(lib lookupSelector: 'setDelegate:')
		to:	manager
		with:	self locationDelegate.

	lib
		sendMessage:	(lib lookupSelector: 'requestWhenInUseAuthorization')
		to:	manager.

	^ manager.
]

{ #category : 'private' }
MacOSLocationRudesheim class >> locationDelegate [
	^ locationDelegate ifNil: [ locationDelegate := self defaultLocationDelegate ].
]

{ #category : 'private' }
MacOSLocationRudesheim class >> defaultLocationDelegate [
	| lib delegateClass instance |
	(DynamicLoader forCurrentPlatform)
		loadLibrary:	'/System/Library/Frameworks/CoreLocation.framework/CoreLocation'
		flag:	2.

	lib := ObjCLibrary uniqueInstance.
	delegateClass := lib
		objc_allocateClassPairSuperclass:	(lib lookupClass: 'NSObject')
		name:	'RudesheimMobileLabLocationDelegate'
		extraBytes:	0.

	delegateCallbacks := OrderedCollection new.
	delegateCallbacks
		add:
		(
			self
				addDelegateCallbackFor:	'locationManager:didUpdateLocations:'
				to:	delegateClass
				using:	lib
				block:	[ :managerArg :locationsArg | self recordUpdatedLocations: locationsArg using: lib ]
		);
		add:
		(
			self
				addDelegateCallbackFor:	'locationManager:didFailWithError:'
				to:	delegateClass
				using:	lib
				block:	[ :managerArg :errorArg | pendingLocationDescription := '' ]
		);
		add:
		(
			self
				addDelegateCallbackFor:	'locationManager:didUpdateHeading:'
				to:	delegateClass
				using:	lib
				block:	[ :managerArg :headingArg | self recordUpdatedHeading: headingArg using: lib ]
		).

	lib objc_registerClassPair: delegateClass.

	instance := lib sendMessage: (lib lookupSelector: 'alloc') to: delegateClass.
	instance := lib sendMessage: (lib lookupSelector: 'init') to: instance.
	^ instance.
]

{ #category : 'private' }
MacOSLocationRudesheim class >> addDelegateCallbackFor: aSelectorString to: aDelegateClass using: lib block: aBlock [
	| callback |
	callback := FFICallback
		signature:	#(void (void* rcvr, void* objCSel, void* arg1, void* arg2))
		block:	[ :arg1 :arg2 | aBlock value: arg1 value: arg2 ].

	lib
		class_addMethodClass:	aDelegateClass
		selector:	(lib lookupSelector: aSelectorString)
		implementation:	callback
		signature:	'v@:@@'.

	^ callback.
]

{ #category : 'private' }
MacOSLocationRudesheim class >> recordUpdatedLocations: locationsArg using: lib [
	| firstLocation description |
	firstLocation := lib sendMessage: (lib lookupSelector: 'firstObject') to: locationsArg.
	description := self
		nsStringToString:	(lib sendMessage: (lib lookupSelector: 'description') to: firstLocation)
		using:	lib.
	pendingLocationDescription := description.
]

{ #category : 'private' }
MacOSLocationRudesheim class >> recordUpdatedHeading: headingArg using: lib [
	pendingHeadingDegrees := lib
		sendDoubleMessage:	(lib lookupSelector: 'trueHeading')
		to:	headingArg.
]

{ #category : 'private' }
MacOSLocationRudesheim class >> nsStringToString: nsString using: lib [
	| cString |
	cString := lib sendMessage: (lib lookupSelector: 'UTF8String') to: nsString.
	^ cString utf8StringFromCString.
]

{ #category : 'private' }
MacOSLocationRudesheim class >> waitUntil: aBlock timeoutSeconds: aNumberOfSeconds [
	| remainingSeconds |
	remainingSeconds := aNumberOfSeconds.
	[ aBlock value or: [ 0 >= remainingSeconds ] ]
		whileFalse:
		[
			(Delay forSeconds: 1) wait.
			remainingSeconds := remainingSeconds - 1.
		].
]

{ #category : 'private' }
MacOSLocationRudesheim class >> signalLocationUnavailable [
	^ self
		error:	'CoreLocation authorization was not granted -- macOS only shows the permission dialog to a process running from a proper .app bundle with an Info.plist NSLocationWhenInUseUsageDescription entry, which this headless Pharo process is not (see note/pharo-ops.md section 41).'.
]
