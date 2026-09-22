"
A KeyTheodoliteMobileLabRudesheim is the namespace for Theodolite's dictionary-key marker classes,
reached as `Rudesheim MobileLab Theodolite Key`. These classes
(BearingLinesKeyTheodoliteMobileLabRudesheim, WarningKeyTheodoliteMobileLabRudesheim) exist only to
be used as ModelTheodoliteMobileLabRudesheim's dictionary keys -- they hold no state and are
distinct from the value-holding BearingLinesTheodoliteMobileLabRudesheim/
WarningTheodoliteMobileLabRudesheim classes. Separating key identity from value storage means a key
can later carry its own behavior (e.g. reading/displaying its own entry from a given Model, see the
usage sketch below) without that behavior getting mixed into the value class itself:

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
