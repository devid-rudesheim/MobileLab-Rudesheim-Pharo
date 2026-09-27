"
A WorldMenuMobileLabRudesheim registers the `MobileLab` World Menu item (the Pharo desktop's
right-click menu), reached as `Rudesheim MobileLab WorldMenu`. Stateless: it exists only for its
class-side `menuOn:` (the `<worldMenu>` pragma method Pharo's `PragmaMenuBuilder` discovers and
invokes to build the real menu -- see e.g. `DebugPoint class>>#menuCommandOn:` for the same
pattern) and `applicationClasses`.

The `MobileLab` item gets one child per `Rudesheim MobileLab * Application` class.
`applicationClasses` finds them by walking the actual namespace, not by guessing from class names:
it calls every `Rudesheim MobileLab class` method filed under the `namespace` protocol (e.g.
`Theodolite`, reached as `Rudesheim MobileLab Theodolite`), keeps the ones that themselves answer
an `Application` class method (e.g. `TheodoliteMobileLabRudesheim class>>#Application`, so a
namespace with no app yet -- or this class's own `WorldMenu` accessor -- is simply skipped), and
collects that `Application` class (e.g. `ApplicationTheodoliteMobileLabRudesheim`). This finds them
fresh every time the menu is built, so a newly added app shows up without touching this class, as
long as its own `Rudesheim MobileLab <X>` namespace-accessor method is filed under `namespace` (see
`MobileLabRudesheim.extension.st` in each app's own package). Each child's displayed label comes
from that class's own `menuLabel` class method (e.g. `Theodolite` for
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
	|
		namespaceClasses
	|

	namespaceClasses :=
		(
			Rudesheim MobileLab class selectors
				select:
				[ :aSelector |
					(
						Rudesheim MobileLab class
							>> aSelector
					) protocol name = #namespace.
				]
		)
			collect:
			[ :aSelector |
				Rudesheim MobileLab
					perform:	aSelector.
			].

	^
	(
		(
			namespaceClasses
				select:
				[ :aNamespaceClass |
					aNamespaceClass class
						canUnderstand:	#Application.
				]
		)
			collect:
			[ :aNamespaceClass |
				aNamespaceClass Application.
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
						action:
						[
							anApplicationClass new run.
						].
				].
		].
]
