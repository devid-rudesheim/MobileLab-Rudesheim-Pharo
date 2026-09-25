"
An ApplicationTheodoliteMobileLabRudesheimTest is a test class for testing that
`Rudesheim MobileLab Theodolite Application` resolves to a working SpApplication subclass.
"
Class {
	#name : 'ApplicationTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite Application.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testNewRunSucceeds [
	self
		shouldnt:
		[
			self basicTarget run.
		]
		raise:	Error.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testStartWiresDiscardButton [
	|
		target
		view
	|

	target := self basicTarget.
	view := target viewLandscape.
	target start.

	target model bearingLines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	view widgets discardButton performAction.

	self
		assert:	target model bearingLines size
		equals:	0.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testStartWiresProgressLabelToModelChanges [
	|
		target
		view
	|

	target := self basicTarget.
	view := target viewLandscape.
	target start.

	target model bearingLines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	self
		assert:	view widgets progressLabel label
		equals:	'1/3 lines'.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testStartWiresRemoveLineButton [
	|
		target
		view
	|

	target := self basicTarget.
	view := target viewLandscape.
	target start.

	target model bearingLines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	view widgets removeLineButton performAction.

	self
		assert:	target model bearingLines size
		equals:	0.
]
