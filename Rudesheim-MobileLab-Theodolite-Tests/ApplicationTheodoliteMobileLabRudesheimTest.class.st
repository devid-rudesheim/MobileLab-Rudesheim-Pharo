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
ApplicationTheodoliteMobileLabRudesheimTest >> testMenuLabel [
	self
		assert:	self targetClass menuLabel
		equals:	'Theodolite'.
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
ApplicationTheodoliteMobileLabRudesheimTest >> testStartupSucceeds [
	"Class-side #startup is what an exported iOS app's startup.st calls. Here (a headless image, no
	World) it must at least not raise; that it really opens Theodolite on the UI process is checked
	in the iOS Simulator, since the tests can't open a World."
	self
		shouldnt:
		[
			self targetClass startup.
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

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testStartWiresPortraitViewToTheSameModel [
	|
		target
		view
	|

	target := self basicTarget.
	view := target viewPortrait.
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
ApplicationTheodoliteMobileLabRudesheimTest >> testViewForLandscapeExtentAnswersViewLandscape [
	self
		assert:
		(
			self basicTarget
				viewFor:	800 @ 600
		)
		equals:	self basicTarget viewLandscape.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testViewForPortraitExtentAnswersViewPortrait [
	self
		assert:
		(
			self basicTarget
				viewFor:	600 @ 800
		)
		equals:	self basicTarget viewPortrait.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testViewForSquareExtentAnswersViewLandscape [
	self
		assert:
		(
			self basicTarget
				viewFor:	600 @ 600
		)
		equals:	self basicTarget viewLandscape.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testWorldMenuApplicationClassesIncludesTheodolite [
	self
		assert:
		(
			Rudesheim MobileLab applicationClasses
				includes:	self targetClass
		).
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testScreenPolicyAccessorRoundTrip [
	|
		target
	|

	target := self basicTarget.

	target
		screenPolicy:	Rudesheim MobileLab ScreenPolicy World.

	self
		assert:	target screenPolicy
		identicalTo:	Rudesheim MobileLab ScreenPolicy World.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testScreenPolicyDefaultsToWindow [
	self
		assert:	self basicTarget screenPolicy
		identicalTo:	Rudesheim MobileLab ScreenPolicy Window.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testStartOpensTheViewForTheWindowExtentThroughTheScreenPolicy [
	|
		target
		policy
	|

	target := self basicTarget.
	policy := Rudesheim MobileLab Theodolite StubScreenPolicy new.

	target
		screenPolicy:	policy.

	target start.

	self
		assert:	policy views asArray
		equals:
		{
			target
				viewFor:	target defaultWindowExtent
		}.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testStartOpensTheViewTitledTheodolite [
	|
		target
		policy
	|

	target := self basicTarget.
	policy := Rudesheim MobileLab Theodolite StubScreenPolicy new.

	target
		screenPolicy:	policy.

	target start.

	self
		assert:	policy titles asArray
		equals:
		{
			'Theodolite'
		}.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testStartRegistersTheWindowTheScreenPolicyAnswers [
	|
		target
		policy
	|

	target := self basicTarget.
	policy := Rudesheim MobileLab Theodolite StubScreenPolicy new.

	target
		screenPolicy:	policy.

	target start.

	self
		assert:
		(
			target windows
				includes:	policy
		).
]
