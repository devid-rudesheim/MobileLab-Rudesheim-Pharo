"
A WindowScreenPolicyMobileLabRudesheimTest is a test class for testing that
`Rudesheim MobileLab ScreenPolicy Window` opens a View as an ordinary window (the behavior
every MobileLab Application had before ScreenPolicy existed).
"
Class {
	#name : 'WindowScreenPolicyMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
WindowScreenPolicyMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab ScreenPolicy Window.
]

{ #category : 'tests' }
WindowScreenPolicyMobileLabRudesheimTest >> testOpenTitledAnswersTheWindowTheViewOpened [
	|
		view
	|

	view := Rudesheim MobileLab ScreenPolicy StubPresenter new.

	self
		assert:
		(
			self targetClass
				open:	view
				titled:	'Theodolite'
		)
		identicalTo:	view.
]

{ #category : 'tests' }
WindowScreenPolicyMobileLabRudesheimTest >> testOpenTitledNeverTakesOverTheWorld [
	|
		view
	|

	view := Rudesheim MobileLab ScreenPolicy StubPresenter new.

	self targetClass
		open:	view
		titled:	'Theodolite'.

	self
		deny:
		(
			view events
				includes:	#asWorldWindow
		).
]

{ #category : 'tests' }
WindowScreenPolicyMobileLabRudesheimTest >> testOpenTitledOpensTheViewThenTitlesTheWindow [
	|
		view
	|

	view := Rudesheim MobileLab ScreenPolicy StubPresenter new.

	self targetClass
		open:	view
		titled:	'Theodolite'.

	self
		assert:	view events asArray
		equals:
		{
			#open.
			( #title: -> 'Theodolite' )
		}.
]
