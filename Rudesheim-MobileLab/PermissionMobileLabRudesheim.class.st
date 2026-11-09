"
A PermissionMobileLabRudesheim is an operating-system permission a MobileLab app asks its user for
(location, and later camera, microphone and so on). It is the abstract root of the permissions and
also the place each concrete one is reached from: `Rudesheim MobileLab Permission LocationService`.

A permission carries the sentence the operating system shows the user when it asks (its
`description`, set with `description:` and defaulted by the subclass), and knows how it is spelled
in an Info.plist (`forPList`, a LookupKey -- a key and nothing else for now; it can become an
Association, which is a LookupKey that also holds a value, once something needs the value there).
Whoever writes the Info.plist (`Rudesheim MobileLab Export InfoPlist`) only asks these two things, so
adding a permission is adding a subclass.
"
Class {
	#name : 'PermissionMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'description'
	],
	#category : 'Rudesheim-MobileLab-Permission',
	#package : 'Rudesheim-MobileLab',
	#tag : 'Permission'
}

{ #category : 'namespace' }
PermissionMobileLabRudesheim class >> LocationService [
	^ LocationServicePermissionMobileLabRudesheim.
]

{ #category : 'instance creation' }
PermissionMobileLabRudesheim class >> description: aString [
	^ self new
		description:	aString;
		yourself.
]

{ #category : 'private' }
PermissionMobileLabRudesheim >> defaultDescription [
	^ self subclassResponsibility.
]

{ #category : 'accessing' }
PermissionMobileLabRudesheim >> description [
	^ description
		ifNil:
		[
			description := self defaultDescription.
		].
]

{ #category : 'accessing' }
PermissionMobileLabRudesheim >> description: aString [
	description := aString.
]

{ #category : 'converting' }
PermissionMobileLabRudesheim >> forPList [
	^ self subclassResponsibility.
]
