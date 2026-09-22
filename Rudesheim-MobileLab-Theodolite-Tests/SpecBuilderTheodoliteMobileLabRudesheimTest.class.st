"
A SpecBuilderTheodoliteMobileLabRudesheimTest verifies bindModel:toView: wires up cleanly against
StubViewTheodoliteMobileLabRudesheim without raising. It does not (yet) verify that changes
actually propagate to real widgets on screen -- that needs a live, opened window, which is out of
scope until the real View presenters exist (see note/ios-triangulation-app.md section 8).
"
Class {
	#name : 'SpecBuilderTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
SpecBuilderTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite SpecBuilder.
]

{ #category : 'tests' }
SpecBuilderTheodoliteMobileLabRudesheimTest >> testBindModelToViewDoesNotRaise [
	|
		theodolite
		app
		view
		model
	|

	theodolite := Rudesheim MobileLab Theodolite.
	app := SpApplication new.
	view := theodolite StubView new.

	view
		application:	app.

	model := theodolite Model new.

	self
		shouldnt:
		[
			self targetClass
				bindModel:	model
				toView:	view.
		]
		raise:	Error.
]

{ #category : 'tests' }
SpecBuilderTheodoliteMobileLabRudesheimTest >> testBoundViewButtonsHaveActions [
	|
		theodolite
		app
		view
		model
	|

	theodolite := Rudesheim MobileLab Theodolite.
	app := SpApplication new.
	view := theodolite StubView new.

	view
		application:	app.

	model := theodolite Model new.

	self targetClass
		bindModel:	model
		toView:	view.

	self
		shouldnt:
		[
			view discardButton performAction.
		]
		raise:	Error.
]

{ #category : 'tests' }
SpecBuilderTheodoliteMobileLabRudesheimTest >> testRemoveLineButtonPopsLastLine [
	|
		theodolite
		app
		view
		model
	|

	theodolite := Rudesheim MobileLab Theodolite.
	app := SpApplication new.
	view := theodolite StubView new.

	view
		application:	app.

	model := theodolite Model new.

	model bearingLines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	self targetClass
		bindModel:	model
		toView:	view.

	view removeLineButton performAction.

	self
		assert:	model bearingLines size
		equals:	0.
]
