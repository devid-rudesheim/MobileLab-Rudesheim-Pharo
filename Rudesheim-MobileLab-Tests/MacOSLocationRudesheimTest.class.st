"
A MacOSLocationRudesheimTest exercises MacOSLocationRudesheim class>>
#addDelegateCallbackFor:to:using:block: in isolation from the real ObjC/CoreLocation runtime (via
StubObjCLibraryLocationMobileLabRudesheim, see its own comment) -- unlike this class's
CoreLocation-dependent primitives (#currentLocation/#currentNormalizedBearing), which
OSLocationRudesheimTest's own comment already documents as untestable headlessly, this method's
own FFICallback wiring is pure Smalltalk plumbing with no OS dependency at all.

#addDelegateCallbackFor:to:using:block: builds an FFICallback whose #signature: declares 4
parameters (Objective-C's own implicit receiver/selector pair, `rcvr`/`objCSel`, plus the delegate
method's own 2 arguments -- `v@:@@`, matching e.g. `locationManager:didUpdateHeading:`), so the
FFICallback's own wrapping block must itself declare 4 parameters to be invoked correctly by the
real FFI trampoline (`FFICallback>>#valueWithArguments:` signals `ArgumentsCountMismatch`
otherwise) -- exactly the crash a real 'Add line' press produced against an earlier version of this
method that declared only 2 parameters and dropped the leading receiver/selector pair instead of
ignoring it.
"
Class {
	#name : 'MacOSLocationRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
MacOSLocationRudesheimTest class >> targetClass [
	^ MacOSLocationRudesheim.
]

{ #category : 'tests' }
MacOSLocationRudesheimTest >> testAddDelegateCallbackForToUsingBlockCallbackAcceptsTheRealFFIArgumentCount [
	|
		receivedArguments
		callback
	|

	receivedArguments := OrderedCollection new.

	callback :=
		self targetClass
			addDelegateCallbackFor:	'locationManager:didUpdateHeading:'
			to:	Object
			using:	StubObjCLibraryLocationMobileLabRudesheim new
			block:
			[ :managerArg :headingArg |
				receivedArguments
					add:	managerArg;
					add:	headingArg.
			].

	self
		shouldnt:
		[
			callback
				valueWithArguments:	{ 1. 2. 3. 4 }.
		]
		raise:	Error.

	self
		assert:	receivedArguments asArray
		equals:	#(3 4).
]

{ #category : 'tests' }
MacOSLocationRudesheimTest >> testAddDelegateCallbackForToUsingBlockRegistersTheBuiltCallback [
	|
		stub
		callback
	|

	stub := StubObjCLibraryLocationMobileLabRudesheim new.

	callback :=
		self targetClass
			addDelegateCallbackFor:	'locationManager:didUpdateHeading:'
			to:	Object
			using:	stub
			block:	[ :managerArg :headingArg |  ].

	self
		assert:	stub registeredImplementation
		equals:	callback.
]
