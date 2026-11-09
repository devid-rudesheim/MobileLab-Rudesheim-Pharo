"
A WorldMenuMobileLabRudesheimTest checks that `Rudesheim MobileLab WorldMenu` resolves (inherited
from BasicRudesheimTest) and, via StubMenuBuilderMobileLabRudesheim (see its own comment),
`menuOn:`'s own use of the builder protocol (#item:/#with:/#label:/#action:) -- but not the real
`<worldMenu>`/`PragmaMenuBuilder` pragma machinery itself, which walks every `<worldMenu>`-tagged
method currently loaded in the image, not just this one, so testing against it here would be both
unrelated to this class and fragile headless. `Rudesheim MobileLab applicationClasses` (the
discovery `menuOn:` builds its items from) has its own tests in MobileLabRudesheimTest.
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
WorldMenuMobileLabRudesheimTest >> testMenuOnAddsOneChildItemPerApplicationClassWithItsMenuLabel [
	|
		builder
	|

	builder := Rudesheim MobileLab WorldMenu StubMenuBuilder new.

	self
		shouldnt:
		[
			self targetClass
				menuOn:	builder.
		]
		raise:	Error.

	Rudesheim MobileLab applicationClasses
		do:
		[ :anApplicationClass |
			|
				item
			|

			item :=
				builder
					itemNamed:	anApplicationClass name.

			self
				assert:	item label
				equals:	anApplicationClass menuLabel.

			self
				assert:	item actionBlock notNil.
		].
]
