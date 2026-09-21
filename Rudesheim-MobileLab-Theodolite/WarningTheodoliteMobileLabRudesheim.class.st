"
A WarningTheodoliteMobileLabRudesheim is a single warning entry held (0-or-1, never nil, per the
project's no-nil convention) by the Model's warning NewValueHolder. Also doubles as that entry's
dictionary key in the Model, mirroring how BearingLineTheodoliteMobileLabRudesheim keys its own
collection entry.
"
Class {
	#name : 'WarningTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'message'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'instance creation' }
WarningTheodoliteMobileLabRudesheim class >> message: aString [
	^ self new
		setMessage:	aString.
]

{ #category : 'accessing' }
WarningTheodoliteMobileLabRudesheim >> message [
	^ message.
]

{ #category : 'private' }
WarningTheodoliteMobileLabRudesheim >> setMessage: aString [
	message := aString.
]
