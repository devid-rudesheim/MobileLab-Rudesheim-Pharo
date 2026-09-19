"
A MobileLabRudesheimTest is a test class for testing the reachability of the Rudesheim MobileLab
namespace. This repository is a mixed dumping ground for mobile-device Pharo application
prototypes; it currently holds only the namespace class, with individual app prototypes added
underneath it later.
"
Class {
	#name : 'MobileLabRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
MobileLabRudesheimTest class >> targetClass [
	^ Rudesheim.
]

{ #category : 'tests' }
MobileLabRudesheimTest >> testMobileLabResolvesFromRudesheim [
	self
		assert:	self class targetClass MobileLab
		equals:	MobileLabRudesheim.
]