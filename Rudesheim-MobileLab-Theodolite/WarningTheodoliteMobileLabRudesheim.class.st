"
A WarningTheodoliteMobileLabRudesheim is a single warning entry held (0-or-1, never nil, per the
project's no-nil convention) by the Model's warning NewValueHolder. Its Model dictionary entry is
keyed separately, by WarningKeyTheodoliteMobileLabRudesheim (see
KeyTheodoliteMobileLabRudesheim's comment) -- this class holds the warning's value, not its key.
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
