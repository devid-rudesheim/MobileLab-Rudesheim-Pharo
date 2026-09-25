"
A KeyTheodoliteMobileLabRudesheim is the namespace for Theodolite's dictionary-key marker classes,
reached as `Rudesheim MobileLab Theodolite Key`. These classes
(BearingLinesKeyTheodoliteMobileLabRudesheim, WarningKeyTheodoliteMobileLabRudesheim) exist only to
be used as ModelTheodoliteMobileLabRudesheim's dictionary keys -- they hold no state. The
BearingLines entry's value is a BearingLinesTheodoliteMobileLabRudesheim; the Warning entry's value
is a plain 0-or-1-element array of message Strings (no separate wrapper class -- there was nothing
for one to add beyond the message itself). Separating key identity from value storage means a key
can later carry its own behavior (e.g. reading/displaying its own entry from a given Model, see the
usage sketch below) without that behavior getting mixed into whatever the entry's value happens to be:

keys := Rudesheim MobileLab Theodolite Key.
{ keys BearingLines. keys Warning } collect: [ :each | each readDisplayStringFrom: model ]

No such behavior is implemented yet -- there is no current caller for it.
"
Class {
	#name : 'KeyTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Theodolite-Namespace',
	#package : 'Rudesheim-MobileLab-Theodolite',
	#tag : 'Namespace'
}

{ #category : 'accessing' }
KeyTheodoliteMobileLabRudesheim class >> BearingLines [
	^ BearingLinesKeyTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
KeyTheodoliteMobileLabRudesheim class >> Warning [
	^ WarningKeyTheodoliteMobileLabRudesheim.
]
