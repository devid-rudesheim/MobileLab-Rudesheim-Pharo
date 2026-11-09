"
A StubPermissionExportMobileLabRudesheim is a second permission for the tests of
`Rudesheim MobileLab Export InfoPlist`, so that an app with several permissions can be tried. Its
description has characters (& < >) that must be escaped when it goes into the Info.plist.
"
Class {
	#name : 'StubPermissionExportMobileLabRudesheim',
	#superclass : 'PermissionMobileLabRudesheim',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'private' }
StubPermissionExportMobileLabRudesheim >> defaultDescription [
	^ 'Stub & <test>'.
]

{ #category : 'converting' }
StubPermissionExportMobileLabRudesheim >> forPList [
	^ LookupKey
		key:	'StubUsageDescription'.
]
