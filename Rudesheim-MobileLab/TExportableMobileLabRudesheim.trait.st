"
A TExportableMobileLabRudesheim names what a MobileLab app's namespace class (like
`Rudesheim MobileLab Theodolite`) must answer for the `Rudesheim MobileLab Export` classes to
prepare the app's exported iOS project -- the members they ask of it, and nothing else:

	`Application`	the app's SpApplication class (it answers the class-side #startup)
	`permissions`	the Rudesheim MobileLab Permission objects the app needs (empty when none)

Both are on the class side, so the trait is composed onto the namespace class's class side
(`#classTraits : 'TExportableMobileLabRudesheim classTrait'`). Here they are only requirements
(#subclassResponsibility): the namespace class defines them, and a `prepareAt:for:` argument is
named after this trait to say so. Reached as `Rudesheim MobileLab Exportable`.
"
Trait {
	#name : 'TExportableMobileLabRudesheim',
	#category : 'Rudesheim-MobileLab-Export',
	#package : 'Rudesheim-MobileLab',
	#tag : 'Export'
}

{ #category : 'namespace' }
TExportableMobileLabRudesheim class >> Application [
	^ self subclassResponsibility.
]

{ #category : 'exporting' }
TExportableMobileLabRudesheim class >> permissions [
	^ self subclassResponsibility.
]
