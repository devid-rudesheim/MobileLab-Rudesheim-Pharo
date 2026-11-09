"
A WorldScreenPolicyMobileLabRudesheimTest is a test class for testing that
`Rudesheim MobileLab ScreenPolicy World` opens a View as the Pharo World itself (the View's
#asWorldWindow, the way Pharo Launcher opens as a world, NocoDB Sections 項番H7) and grows the
World's container Morph to the World's bounds.

Every test goes through StubPresenterMobileLabRudesheim, never a real SpPresenter: a real
#asWorldWindow is irreversible (it deletes every morph of the World), so running it from a test
would wreck the image the test runner is running in.
"
Class {
	#name : 'WorldScreenPolicyMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
WorldScreenPolicyMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab ScreenPolicy World.
]

{ #category : 'tests' }
WorldScreenPolicyMobileLabRudesheimTest >> testOpenTitledAnswersTheWorldWindow [
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
		identicalTo:	view worldWindow.
]

{ #category : 'tests' }
WorldScreenPolicyMobileLabRudesheimTest >> testOpenTitledGrowsTheWorldContainerOnlyAfterOpeningTheWorldWindow [
	|
		view
	|

	view := Rudesheim MobileLab ScreenPolicy StubPresenter new.

	self targetClass
		open:	view
		titled:	'Theodolite'.

	self
		assert:	view worldWindow events asArray
		equals:
		{
			( #title: -> 'Theodolite' ).
			#open.
			#defer:
		}.
]

{ #category : 'tests' }
WorldScreenPolicyMobileLabRudesheimTest >> testOpenTitledGrowsTheWorldContainerToTheWorldBounds [
	|
		view
		world
	|

	view := Rudesheim MobileLab ScreenPolicy StubPresenter new.
	world := view worldWindow currentWorld.

	self targetClass
		open:	view
		titled:	'Theodolite'.

	self
		assert:	world submorphs first bounds
		equals:	world bounds.
]

{ #category : 'tests' }
WorldScreenPolicyMobileLabRudesheimTest >> testOpenTitledSendsAsWorldWindowToTheView [
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
			#asWorldWindow
		}.
]
