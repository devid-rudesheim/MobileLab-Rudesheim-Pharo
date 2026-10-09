"
A MobileLabRudesheimTest is a test class for testing the reachability of the Rudesheim MobileLab
namespace, plus (via TApplicationDiscoveryMobileLabRudesheim, composed onto its class side)
#applicationClasses -- the discovery logic WorldMenuMobileLabRudesheim class>>#menuOn: builds the
`MobileLab` World Menu item from. Only structural assertions belong here (this package doesn't
require any individual app package -- see the class comment above); an app-specific check that a
given app's class is actually found belongs in that app's own Tests package instead (e.g.
Rudesheim-MobileLab-Theodolite-Tests' ApplicationTheodoliteMobileLabRudesheimTest).
"
Class {
	#name : 'MobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
MobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab.
]

{ #category : 'tests' }
MobileLabRudesheimTest >> testApplicationClassesEachRespondToMenuLabel [
	self targetClass applicationClasses
		do:
		[ :anApplicationClass |
			self
				assert:
				(
					anApplicationClass
						respondsTo:	#menuLabel
				).

			self
				assert:	anApplicationClass menuLabel isString.
		].
]

{ #category : 'tests' }
MobileLabRudesheimTest >> testApplicationClassesExcludesNamespacesWithoutAnApplication [
	"Rudesheim MobileLab WorldMenu itself is a namespace accessor (Rudesheim MobileLab class>>
	#WorldMenu, protocol #namespace) whose target -- WorldMenuMobileLabRudesheim -- has no
	class-side #Application, so #applicationClasses must skip it rather than looping back on it."
	self
		deny:
		(
			self targetClass applicationClasses
				includes:	self targetClass WorldMenu
		).
]

{ #category : 'tests' }
MobileLabRudesheimTest >> testApplicationClassesExcludesExportAndPermission [
	"Neither Rudesheim MobileLab Export nor Rudesheim MobileLab Permission is an app (neither answers
	a class-side #Application), and neither is the trait Rudesheim MobileLab Exportable (it declares
	#Application only as a requirement), so #applicationClasses must not list anything of theirs."
	self
		deny:
		(
			self targetClass applicationClasses
				anySatisfy:
				[ :anApplicationClass |
					anApplicationClass category
						beginsWith:	'Rudesheim-MobileLab-Export'.
				]
		).

	self
		deny:
		(
			self targetClass applicationClasses
				anySatisfy:
				[ :anApplicationClass |
					anApplicationClass category
						beginsWith:	'Rudesheim-MobileLab-Permission'.
				]
		).
]

{ #category : 'tests' }
MobileLabRudesheimTest >> testExportAndPermissionAreReachable [
	self
		assert:	self targetClass Export name
		equals:	#ExportMobileLabRudesheim.

	self
		assert:	self targetClass Permission name
		equals:	#PermissionMobileLabRudesheim.
]

{ #category : 'tests' }
MobileLabRudesheimTest >> testExportableNamesTheApplicationClassTheExportClassesAsk [
	self
		assert:
		(
			self targetClass Exportable classTrait
				includesSelector:	#Application
		).
]

{ #category : 'tests' }
MobileLabRudesheimTest >> testExportableNamesThePermissionsTheExportClassesAsk [
	self
		assert:
		(
			self targetClass Exportable classTrait
				includesSelector:	#permissions
		).
]
