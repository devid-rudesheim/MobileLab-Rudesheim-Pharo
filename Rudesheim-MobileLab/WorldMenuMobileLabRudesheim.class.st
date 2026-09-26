"
A WorldMenuMobileLabRudesheim registers the `MobileLab` World Menu item (the Pharo desktop's
right-click menu), reached as `Rudesheim MobileLab WorldMenu`. Stateless: it exists only for its
class-side `menuOn:` (the `<worldMenu>` pragma method Pharo's `PragmaMenuBuilder` discovers and
invokes to build the real menu -- see e.g. `DebugPoint class>>#menuCommandOn:` for the same
pattern) and `applicationClasses`.

The `MobileLab` item gets one child per `Rudesheim MobileLab * Application` class (any loaded
`SpApplication` subclass whose name ends with `MobileLabRudesheim`, e.g.
`ApplicationTheodoliteMobileLabRudesheim`) -- `applicationClasses` finds them fresh every time the
menu is built, so a newly added app shows up without touching this class. Each child's displayed
label comes from that class's own `menuLabel` class method (e.g. `Theodolite` for
`ApplicationTheodoliteMobileLabRudesheim`); its action is `aClass new run`.
"
Class {
	#name : 'WorldMenuMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'discovery' }
WorldMenuMobileLabRudesheim class >> applicationClasses [
	^
	(
		SpApplication allSubclasses
			select:
			[ :anApplicationClass |
				anApplicationClass name endsWith: 'MobileLabRudesheim'.
			]
	)
		asSortedCollection:
		[ :aClass :anotherClass |
			aClass menuLabel <= anotherClass menuLabel.
		].
]

{ #category : 'menu' }
WorldMenuMobileLabRudesheim class >> menuOn: aBuilder [
	<worldMenu>

	(
		aBuilder
			item:	#MobileLab
	)
		with:
		[
			self applicationClasses
				do:
				[ :anApplicationClass |
					(
						aBuilder
							item:	anApplicationClass name
					)
						label:	anApplicationClass menuLabel;
						action:	[ anApplicationClass new run ].
				].
		].
]
