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
	| app view model |
	app := SpApplication new.
	view := StubViewTheodoliteMobileLabRudesheim new.
	view application: app.
	model := Rudesheim MobileLab Theodolite Model new.

	self shouldnt: [ self targetClass bindModel: model toView: view ] raise: Error.
]

{ #category : 'tests' }
SpecBuilderTheodoliteMobileLabRudesheimTest >> testBoundViewButtonsHaveActions [
	| app view model |
	app := SpApplication new.
	view := StubViewTheodoliteMobileLabRudesheim new.
	view application: app.
	model := Rudesheim MobileLab Theodolite Model new.
	self targetClass bindModel: model toView: view.

	self shouldnt: [ view discardButton performAction ] raise: Error.
]