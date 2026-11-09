"
A StubObjCLibraryLocationMobileLabRudesheim is a minimal double for the ObjCLibrary-shaped
`using:` argument MacOSLocationRudesheim class>>#addDelegateCallbackFor:to:using:block: needs, so
that method's own FFICallback wiring -- specifically, that the wrapping block declares the same
number of parameters as its own #signature: -- can be tested headlessly (see
MacOSLocationRudesheimTest's own comment) without touching the real macOS ObjC/CoreLocation
runtime.

#lookupSelector: just echoes its argument back (its actual value never matters here, only that
something flows through to #class_addMethodClass:selector:implementation:signature:'s own
`selector:` argument); #class_addMethodClass:selector:implementation:signature: records its
`implementation:` argument (the FFICallback #addDelegateCallbackFor:to:using:block: built) instead
of registering anything with a real Objective-C runtime.
"
Class {
	#name : 'StubObjCLibraryLocationMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'registeredImplementation'
	],
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'stubbing' }
StubObjCLibraryLocationMobileLabRudesheim >> class_addMethodClass: aClass
selector: aSymbol
implementation: anFFICallback
signature: aSignatureString [
	registeredImplementation := anFFICallback.
]

{ #category : 'stubbing' }
StubObjCLibraryLocationMobileLabRudesheim >> lookupSelector: aSelectorString [
	^ aSelectorString.
]

{ #category : 'accessing' }
StubObjCLibraryLocationMobileLabRudesheim >> registeredImplementation [
	^ registeredImplementation.
]
