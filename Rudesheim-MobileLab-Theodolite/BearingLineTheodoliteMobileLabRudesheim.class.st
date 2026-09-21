"
A BearingLineTheodoliteMobileLabRudesheim is one recorded bearing line: the current location
(origin, a GPoint of longitude@latitude) and the compass bearing (0-360 degrees, true north) the
user was pointing the device toward when they recorded it, plus the timestamp. See
note/ios-triangulation-app.md section 3 (NocoDB Sections 項番FE) in the main project repository.
"
Class {
	#name : 'BearingLineTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'origin',
		'bearing',
		'timestamp'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'instance creation' }
BearingLineTheodoliteMobileLabRudesheim class >> origin: aGPoint
bearing: aNumber [
	^ self new
		setOrigin:	aGPoint
		bearing:	aNumber.
]

{ #category : 'accessing' }
BearingLineTheodoliteMobileLabRudesheim >> bearing [
	^ bearing.
]

{ #category : 'accessing' }
BearingLineTheodoliteMobileLabRudesheim >> origin [
	^ origin.
]

{ #category : 'geometry' }
BearingLineTheodoliteMobileLabRudesheim >> ray [
	"trueHeading is a compass bearing (0=north, clockwise). On the origin+longitude@latitude
	plane that is dx=sin(bearing), dy=cos(bearing); GRay direction: wants a point on the ray, not
	a bare vector, so we offset origin by the unit vector."
	|
		angle
	|

	angle := self bearing degrees.

	^ GRay
		origin:	self origin
		direction:	self origin + ( angle sin , angle cos ).
]

{ #category : 'private' }
BearingLineTheodoliteMobileLabRudesheim >> setOrigin: aGPoint
bearing: aNumber [
	origin := aGPoint.
	bearing := aNumber.
	timestamp := DateAndTime now.
]

{ #category : 'accessing' }
BearingLineTheodoliteMobileLabRudesheim >> timestamp [
	^ timestamp.
]
