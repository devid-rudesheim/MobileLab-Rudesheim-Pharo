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
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutPlacesMapAreaFirst [
	self
		assert:	self basicTarget widgets mapArea == self basicTarget defaultLayout children first.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutPlacesWarningLabelLastAsItsOwnRow [
	self
		assert:	self basicTarget widgets warningLabel == self basicTarget defaultLayout children last.
]

{ #category : 'tests' }
ViewPortraitTheodoliteMobileLabRudesheimTest >> testDefaultLayoutStacksFourRows [
	self
		assert:	self basicTarget defaultLayout children size
		equals:	4.
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
		assert:	self basicTarget widgets == self basicTarget widgets.
]
