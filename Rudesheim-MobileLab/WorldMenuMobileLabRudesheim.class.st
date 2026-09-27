"
A WorldMenuMobileLabRudesheim registers the `MobileLab` World Menu item (the Pharo desktop's
right-click menu), reached as `Rudesheim MobileLab WorldMenu`. Stateless: it exists only for its
class-side `menuOn:` (the `<worldMenu>` pragma method Pharo's `PragmaMenuBuilder` discovers and
invokes to build the real menu -- see e.g. `DebugPoint class>>#menuCommandOn:` for the same
pattern).

The `MobileLab` item gets one child per `Rudesheim MobileLab * Application` class, found via
`Rudesheim MobileLab applicationClasses` (`MobileLabRudesheim class`'s own discovery, composed in
from `TApplicationDiscoveryMobileLabRudesheim` -- see that trait's comment for how it walks the
namespace). Each child's displayed label comes from that class's own `menuLabel` class method
(e.g. `Theodolite` for `ApplicationTheodoliteMobileLabRudesheim`); its action is `aClass new run`.
"
Class {
	#name : 'WorldMenuMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'menu' }
WorldMenuMobileLabRudesheim class >> menuOn: aBuilder [
	<worldMenu>

	(
		aBuilder
			item:	#MobileLab
	)
		with:
		[
			Rudesheim MobileLab applicationClasses
				do:
				[ :anApplicationClass |
					(
						aBuilder
							item:	anApplicationClass name
					)
						label:	anApplicationClass menuLabel;
						action:
						[
							anApplicationClass new run.
						].
				].
		].
]
