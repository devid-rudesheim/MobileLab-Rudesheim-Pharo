"
A StubMenuBuilderMobileLabRudesheim is a minimal double for the PragmaMenuBuilder-shaped argument
WorldMenuMobileLabRudesheim class>>#menuOn: needs, so that method's own use of the
#item:/#with:/#label:/#action: builder protocol can be tested in isolation -- unlike the real,
image-wide `<worldMenu>`/`PragmaMenuBuilder` pragma machinery (which walks every `<worldMenu>`-
tagged method currently loaded, not just this one, and so would be fragile to test against
headless -- see WorldMenuMobileLabRudesheimTest's own comment), this double only ever sees
#menuOn:'s own calls.

#item: answers a StubMenuItemMobileLabRudesheim, memoized per name so a later #itemNamed: can find
the same one #menuOn: configured (mirroring how a real menu item is identified by name).
"
Class {
	#name : 'StubMenuBuilderMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'items'
	],
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'initialization' }
StubMenuBuilderMobileLabRudesheim >> initialize [
	super initialize.

	items := Dictionary new.
]

{ #category : 'stubbing' }
StubMenuBuilderMobileLabRudesheim >> item: aSymbol [
	^ items
		at:	aSymbol
		ifAbsentPut:
		[
			StubMenuItemMobileLabRudesheim new.
		].
]

{ #category : 'accessing' }
StubMenuBuilderMobileLabRudesheim >> itemNamed: aSymbol [
	^ items at: aSymbol.
]
