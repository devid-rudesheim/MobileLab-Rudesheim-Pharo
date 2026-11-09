"
A LocationServicePermissionMobileLabRudesheimTest is a test class for testing
`Rudesheim MobileLab Permission LocationService` (and, through it, what every permission
inherits from PermissionMobileLabRudesheim: the `description` with its default, and `description:`).
"
Class {
	#name : 'LocationServicePermissionMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
LocationServicePermissionMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Permission LocationService.
]

{ #category : 'tests' }
LocationServicePermissionMobileLabRudesheimTest >> testAbstractPermissionLeavesForPListToItsSubclasses [
	self
		should:
		[
			Rudesheim MobileLab Permission new forPList.
		]
		raise:	Error.
]

{ #category : 'tests' }
LocationServicePermissionMobileLabRudesheimTest >> testDescriptionColonAnswersAnInstanceHoldingTheDescription [
	|
		permission
	|

	permission :=
		self targetClass
			description:	'Because.'.

	self
		assert:	permission class
		equals:	self targetClass.

	self
		assert:	permission description
		equals:	'Because.'.
]

{ #category : 'tests' }
LocationServicePermissionMobileLabRudesheimTest >> testDescriptionColonDoesNotChangeTheDefaultOfOtherInstances [
	self targetClass
		description:	'Because.'.

	self
		assert:	self targetClass new description
		equals:	self basicTarget description.
]

{ #category : 'tests' }
LocationServicePermissionMobileLabRudesheimTest >> testDescriptionDefaultsToANonEmptySentence [
	self
		deny:	self basicTarget description isEmpty.
]

{ #category : 'tests' }
LocationServicePermissionMobileLabRudesheimTest >> testForPListAnswersALookupKey [
	self
		assert:	self basicTarget forPList class
		equals:	LookupKey.
]

{ #category : 'tests' }
LocationServicePermissionMobileLabRudesheimTest >> testForPListAnswersTheLocationUsageDescriptionKey [
	self
		assert:	self basicTarget forPList key
		equals:	'NSLocationWhenInUseUsageDescription'.
]
