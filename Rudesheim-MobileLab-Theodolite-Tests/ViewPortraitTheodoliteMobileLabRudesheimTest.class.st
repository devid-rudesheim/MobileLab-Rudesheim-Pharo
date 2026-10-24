"
A ViewPortraitTheodoliteMobileLabRudesheimTest is a test class for testing that
`Rudesheim MobileLab Theodolite ViewPortrait` arranges the shared widget set into the portrait
structure of note/ios-triangulation-app.md section 2.1 (NocoDB Sections 項番FD §2.1, with the
warning row placement of 項番GO).
"
Class {
	#name : 'ViewPortraitTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
ViewPortraitTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite ViewPortrait.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutGivesAddLineButtonThreeTimesAStandardButtonHeight [
	|
		layout
	|

	layout := self basicTarget defaultLayout.

	self
		assert:
		(
			layout
				constraintsFor:	self basicTarget widgets addLineButton
		) height
		equals:	self basicTarget buttonHeight * 3.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutGivesTopRowTheTopInsetHeight [
	|
		layout
	|

	layout := self basicTarget defaultLayout.

	self
		assert:
		(
			layout
				constraintsFor:	layout children first
		) height
		equals:	self basicTarget topInset.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutPlacesAnEmptyRowFirst [
	self
		assert:	self basicTarget defaultLayout children first children
		equals:	#(  ).
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutPlacesAddLineButtonSixth [
	self
		assert:	self basicTarget defaultLayout children sixth
		identicalTo:	self basicTarget widgets addLineButton.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutPlacesMapAreaThird [
	self
		assert:	self basicTarget defaultLayout children third
		identicalTo:	self basicTarget widgets mapArea.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutPlacesProgressLabelFourth [
	self
		assert:	self basicTarget defaultLayout children fourth
		identicalTo:	self basicTarget widgets progressLabel.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutPlacesRarelyUsedRowSecondWithAddressBarInIt [
	self
		assert:
		(
			self basicTarget defaultLayout children second children
				includes:	self basicTarget widgets addressBar
		).
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutPlacesRemoveLineButtonFifth [
	self
		assert:	self basicTarget defaultLayout children fifth
		identicalTo:	self basicTarget widgets removeLineButton.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutPlacesWarningLabelLastAsItsOwnRow [
	self
		assert:	self basicTarget defaultLayout children last
		identicalTo:	self basicTarget widgets warningLabel.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutStacksSevenRows [
	self
		assert:	self basicTarget defaultLayout children size
		equals:	7.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testOpenSucceeds [
	|
		app
		window
	|

	app := SpApplication new.

	self basicTarget
		application:	app.

	self
		shouldnt:
		[
			window := self basicTarget open.
		]
		raise:	Error.

	window close.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testWidgetsAreLazilyCreatedOnceAndShared [
	self
		assert:	self basicTarget widgets
		identicalTo:	self basicTarget widgets.
]
