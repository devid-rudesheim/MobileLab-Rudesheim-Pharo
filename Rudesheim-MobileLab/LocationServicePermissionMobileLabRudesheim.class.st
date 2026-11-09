"
A LocationServicePermissionMobileLabRudesheim is the permission to read the device's location (and
heading) while the app is in use. In an Info.plist it is the usage-description key
NSLocationWhenInUseUsageDescription; without it the app never gets the system's permission prompt
and every location request is silently denied.
"
Class {
	#name : 'LocationServicePermissionMobileLabRudesheim',
	#superclass : 'PermissionMobileLabRudesheim',
	#category : 'Rudesheim-MobileLab-Permission',
	#package : 'Rudesheim-MobileLab',
	#tag : 'Permission'
}

{ #category : 'private' }
LocationServicePermissionMobileLabRudesheim >> defaultDescription [
	^ 'This app uses your location.'.
]

{ #category : 'converting' }
LocationServicePermissionMobileLabRudesheim >> forPList [
	^ LookupKey
		key:	'NSLocationWhenInUseUsageDescription'.
]
