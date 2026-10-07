"
A StubBareAppExportMobileLabRudesheim is an app namespace class without any permission, for the tests
of `Rudesheim MobileLab Export InfoPlist` that must leave the file alone.
"
Class {
	#name : 'StubBareAppExportMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
StubBareAppExportMobileLabRudesheim class >> Application [
	^ StubApplicationExportMobileLabRudesheim.
]

{ #category : 'exporting' }
StubBareAppExportMobileLabRudesheim class >> permissions [
	^ #(  ).
]
