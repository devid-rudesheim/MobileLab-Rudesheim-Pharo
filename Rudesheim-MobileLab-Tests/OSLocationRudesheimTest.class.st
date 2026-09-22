"
An OSLocationRudesheimTest verifies OSLocationRudesheim's OS-dispatch wiring (mirroring
OSTableQueryRudesheimTest's own #testDelegatesThroughRudesheimOSDispatch pattern) and that the
base/unsupported implementation signals cleanly for all three class-side methods -- the two
primitives (#currentLocation/#currentNormalizedBearing) and the #currentRay template method built
from them (which surfaces the same subclassResponsibility, since it calls the primitives). It does
not exercise MacOSLocationRudesheim's own primitive overrides -- those depend on the
not-yet-implemented CLLocationManagerAgent/CLHeadingAgent ObjC bridge (see
MacOSLocationRudesheim's comment) and would fail with an uncontrolled DNU rather than a clean
assertion, on whichever platform actually resolves to it.
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
OSLocationRudesheimTest >> testCurrentLocationIsSubclassResponsibility [
	self
		should:
		[
			OSLocationRudesheim currentLocation.
		]
		raise:	Error.
]

{ #category : 'tests' }
OSLocationRudesheimTest >> testCurrentNormalizedBearingIsSubclassResponsibility [
	self
		should:
		[
			OSLocationRudesheim currentNormalizedBearing.
		]
		raise:	Error.
]

{ #category : 'tests' }
OSLocationRudesheimTest >> testCurrentRayIsSubclassResponsibility [
	self
		should:
		[
			OSLocationRudesheim currentRay.
		]
		raise:	Error.
]

{ #category : 'tests' }
OSLocationRudesheimTest >> testMacDispatchResolvesToMacOSLocationRudesheim [
	self
		assert:	Rudesheim OS Mac location
		equals:	MacOSLocationRudesheim.
]
