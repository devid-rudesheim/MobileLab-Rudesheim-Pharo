"
An OSLauncherRudesheimTest verifies OSLauncherRudesheim's OS-dispatch wiring (mirroring
OSLocationRudesheimTest's own pattern) and that the base/unsupported implementation signals
cleanly. It does not exercise MacOSLauncherRudesheim's own #open: override -- that has a real
side effect (launches another application via NSWorkspace) with no headless-safe way to assert on
it.
"
Class {
	#name : 'OSLauncherRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
OSLauncherRudesheimTest class >> targetClass [
	^ Rudesheim OS launcher.
]

{ #category : 'tests' }
OSLauncherRudesheimTest >> testOpenIsSubclassResponsibility [
	self
		should:
		[
			OSLauncherRudesheim open: 'https://example.com' asZnUrl.
		]
		raise:	Error.
]

{ #category : 'tests' }
OSLauncherRudesheimTest >> testMacDispatchResolvesToMacOSLauncherRudesheim [
	self
		assert:	Rudesheim OS Mac launcher
		equals:	MacOSLauncherRudesheim.
]
