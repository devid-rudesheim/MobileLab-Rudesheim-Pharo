"
A StubMenuItemMobileLabRudesheim is the object StubMenuBuilderMobileLabRudesheim's own #item:
answers, standing in for whatever a real PragmaMenuBuilder's own `item:` answers (see
StubMenuBuilderMobileLabRudesheim's comment for why). #with: evaluates its block immediately
(rather than deferring it to some later menu-opening step), since #menuOn:'s own use of it needs
its nested `aBuilder item:...` sends to have happened by the time a test inspects the builder.
"
Class {
	#name : 'StubMenuItemMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'label',
		'actionBlock'
	],
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'stubbing' }
StubMenuItemMobileLabRudesheim >> action: aBlock [
	actionBlock := aBlock.
]

{ #category : 'accessing' }
StubMenuItemMobileLabRudesheim >> actionBlock [
	^ actionBlock.
]

{ #category : 'stubbing' }
StubMenuItemMobileLabRudesheim >> label: aString [
	label := aString.
]

{ #category : 'accessing' }
StubMenuItemMobileLabRudesheim >> label [
	^ label.
]

{ #category : 'stubbing' }
StubMenuItemMobileLabRudesheim >> with: aBlock [
	aBlock value.
]
