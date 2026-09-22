"
An OSLocationRudesheimTest verifies OSLocationRudesheim's OS-dispatch wiring (mirroring
OSTableQueryRudesheimTest's own #testDelegatesThroughRudesheimOSDispatch pattern) and that the
base/unsupported implementation signals cleanly. It does not exercise MacOSLocationRudesheim>>
#currentRay itself -- that depends on the not-yet-implemented CLLocationManagerAgent/CLHeadingAgent
ObjC bridge (see MacOSLocationRudesheim's comment) and would fail with an uncontrolled DNU rather
than a clean assertion, on whichever platform actually resolves to it.
"
Class {
	#name : 'OSLocationRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
OSLocationRudesheimTest class >> targetClass [
	^ Rudesheim OS location.
]

{ #category : 'tests' }
OSLocationRudesheimTest >> testCurrentRayIsSubclassResponsibility [
	self
		should:	[ OSLocationRudesheim currentRay ]
		raise:	Error.
]

{ #category : 'tests' }
OSLocationRudesheimTest >> testMacDispatchResolvesToMacOSLocationRudesheim [
	self
		assert:	Rudesheim OS Mac location
		equals:	MacOSLocationRudesheim.
]
