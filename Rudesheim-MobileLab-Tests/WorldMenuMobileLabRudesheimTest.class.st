"
A WorldMenuMobileLabRudesheimTest only checks that `Rudesheim MobileLab WorldMenu` resolves
(inherited from BasicRudesheimTest). `menuOn:` itself isn't exercised here: it's a thin adapter
over `Rudesheim MobileLab applicationClasses` (see TApplicationDiscoveryMobileLabRudesheimTest for
that discovery logic's own tests) plus the real `<worldMenu>`/`PragmaMenuBuilder` pragma machinery,
which walks every `<worldMenu>`-tagged method currently loaded in the image, not just this one --
testing against it here would be both unrelated to this class and fragile headless.
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
