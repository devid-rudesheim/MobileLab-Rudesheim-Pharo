"
TApplicationDiscoveryMobileLabRudesheim gives a namespace class (applied to its class side, e.g.
`MobileLabRudesheim class`) the ability to find its own `* Application` classes by walking its
own namespace: `applicationClasses` calls every one of the receiver's own class-side methods filed
under the `namespace` protocol (e.g. `MobileLabRudesheim class>>#Theodolite`), keeps the results
that themselves answer a class-side `Application` (so a namespace with no app yet is simply
skipped), and collects that `Application` class (e.g. `ApplicationTheodoliteMobileLabRudesheim`).

`WorldMenuMobileLabRudesheim class>>#menuOn:` uses this (via `Rudesheim MobileLab
applicationClasses`) to build the `MobileLab` World Menu item -- see its own comment. Applying the
discovery to the namespace class itself, rather than to `WorldMenuMobileLabRudesheim`, keeps it
where the namespace structure being walked actually lives.
"
Trait {
	#name : 'TApplicationDiscoveryMobileLabRudesheim',
	#category : 'Rudesheim-MobileLab',
	#package : 'Rudesheim-MobileLab'
}

{ #category : 'discovery' }
TApplicationDiscoveryMobileLabRudesheim class >> applicationClasses [
	|
		namespaceClasses
	|

	namespaceClasses :=
		(
			self class selectors
				select:
				[ :aSelector |
					(
						self class
							>> aSelector
					) protocol name = #namespace.
				]
		)
			collect:
			[ :aSelector |
				self
					perform:	aSelector.
			].

	namespaceClasses :=
		namespaceClasses
			reject:
			[ :aNamespaceClass |
				aNamespaceClass isTrait.
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
