"
A TExportableMobileLabRudesheim names what a MobileLab app's namespace class (like
`Rudesheim MobileLab Theodolite`) must answer for the `Rudesheim MobileLab Export` classes to
prepare the app's exported iOS project -- the members they ask of it, and nothing else:

	`application`	the app's SpApplication class (it answers the class-side #startup); an app
			namespace has it answer its own `Application` branch: `application ^ self Application`
	`permissions`	the Rudesheim MobileLab Permission objects the app needs (empty when none)

Both are on the class side, so the trait is composed onto the namespace class's class side
(`#classTraits : 'TExportableMobileLabRudesheim classTrait'`). Here they are only requirements
(#subclassResponsibility): the namespace class defines them, and a `prepareAt:for:` argument is
named after this trait to say so. It is a part an app composes, not a branch of the Rudesheim
MobileLab namespace, so it has no accessor there and `applicationClasses` never meets it.
"
Trait {
	#name : 'TExportableMobileLabRudesheim',
	#category : 'Rudesheim-MobileLab-Export',
	#package : 'Rudesheim-MobileLab',
	#tag : 'Export'
}

{ #category : 'accessing' }
TExportableMobileLabRudesheim class >> application [
	^ self subclassResponsibility.
]

{ #category : 'accessing' }
TExportableMobileLabRudesheim class >> permissions [
	^ self subclassResponsibility.
]
