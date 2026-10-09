"
A StubBareAppExportMobileLabRudesheim is an app namespace class without any permission, for the tests
of `Rudesheim MobileLab Export InfoPlist` that must leave the file alone.
"
Class {
	#name : 'StubBareAppExportMobileLabRudesheim',
	#superclass : 'Object',
	#classTraits : 'TExportableMobileLabRudesheim classTrait',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'namespace' }
StubBareAppExportMobileLabRudesheim class >> Application [
	^ Rudesheim MobileLab Export StubApplication.
]

{ #category : 'exporting' }
StubBareAppExportMobileLabRudesheim class >> permissions [
	^ #(  ).
]
