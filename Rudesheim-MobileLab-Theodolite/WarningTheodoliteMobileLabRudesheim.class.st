"
A WarningTheodoliteMobileLabRudesheim is a single warning entry held (0-or-1, never nil, per the
project's no-nil convention) by the Model's warning NewValueHolder. Also doubles as that entry's
dictionary key in the Model, mirroring how BearingLinesTheodoliteMobileLabRudesheim keys its own
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
		message:	aString;
		yourself.
]

{ #category : 'accessing' }
WarningTheodoliteMobileLabRudesheim >> message [
	^ message.
]

{ #category : 'accessing' }
WarningTheodoliteMobileLabRudesheim >> message: aString [
	message := aString.
]
