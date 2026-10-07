"
A StubAppExportMobileLabRudesheim stands for an app's namespace class (like `Rudesheim MobileLab
Theodolite`) in the tests of `Rudesheim MobileLab Export` classes: it answers an `Application` class
and two `permissions`.
"
Class {
	#name : 'StubAppExportMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
StubAppExportMobileLabRudesheim class >> Application [
	^ StubApplicationExportMobileLabRudesheim.
]

{ #category : 'exporting' }
StubAppExportMobileLabRudesheim class >> permissions [
	^
	{
		Rudesheim MobileLab Permission LocationService new.
		StubPermissionExportMobileLabRudesheim new
	}.
]
