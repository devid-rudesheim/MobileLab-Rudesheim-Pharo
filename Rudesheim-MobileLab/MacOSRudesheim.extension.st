Extension { #name : 'MacOSRudesheim' }

{ #category : '*Rudesheim-MobileLab' }
MacOSRudesheim class >> launcher [
	^ MacOSLauncherRudesheim.
]

{ #category : '*Rudesheim-MobileLab' }
MacOSRudesheim class >> location [
	^ MacOSLocationRudesheim.
]

{ #category : '*Rudesheim-MobileLab' }
MacOSRudesheim class >> locationUnavailable [
	^ LocationUnavailableMobileLabRudesheim.
]
