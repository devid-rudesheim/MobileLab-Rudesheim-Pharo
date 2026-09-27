"
A WorldMenuMobileLabRudesheimTest tests `WorldMenuMobileLabRudesheim class>>#applicationClasses`
(the discovery logic `menuOn:` builds the `MobileLab` World Menu item from) directly, rather than
exercising the real `<worldMenu>` pragma machinery (`PragmaMenuBuilder`) -- that machinery walks
every `<worldMenu>`-tagged method currently loaded in the image, not just this one, so testing
against it here would be both unrelated to this class and fragile headless.

Only structural assertions belong here (this package doesn't require any individual app package --
see MobileLabRudesheimTest's comment); an app-specific check that a given app's class is actually
found belongs in that app's own Tests package instead (e.g.
Rudesheim-MobileLab-Theodolite-Tests' ApplicationTheodoliteMobileLabRudesheimTest).
"
Class {
	#name : 'WorldMenuMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
WorldMenuMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab WorldMenu.
]

{ #category : 'tests' }
WorldMenuMobileLabRudesheimTest >> testApplicationClassesExcludesNamespacesWithoutAnApplication [
	"Rudesheim MobileLab WorldMenu itself is a namespace accessor (Rudesheim MobileLab class>>
	#WorldMenu, protocol #namespace) whose target -- this very class -- has no class-side
	#Application, so #applicationClasses must skip it rather than looping back on itself."
	self
		deny:
		(
			self targetClass applicationClasses
				includes:	self targetClass
		).
]

{ #category : 'tests' }
WorldMenuMobileLabRudesheimTest >> testApplicationClassesEachRespondToMenuLabel [
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
