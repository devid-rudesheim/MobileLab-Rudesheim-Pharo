"
A StubAppExportMobileLabRudesheim stands for an app's namespace class (like `Rudesheim MobileLab
Theodolite`) in the tests of `Rudesheim MobileLab Export` classes: it answers an `Application` class
and two `permissions`.
"
Class {
	#name : 'StubAppExportMobileLabRudesheim',
	#superclass : 'Object',
	#classTraits : 'TExportableMobileLabRudesheim classTrait',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'namespace' }
StubAppExportMobileLabRudesheim class >> Application [
	^ Rudesheim MobileLab Export StubApplication.
]

{ #category : 'exporting' }
StubAppExportMobileLabRudesheim class >> permissions [
	^
	{
		Rudesheim MobileLab Permission LocationService new.
		Rudesheim MobileLab Export StubPermission new
	}.
]
