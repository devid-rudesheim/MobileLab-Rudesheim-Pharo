"
An ApplicationTheodoliteMobileLabRudesheim is the SpApplication for Theodolite, the iOS
bearing-line triangulation prototype (resection from three recorded bearings, see
note/ios-triangulation-app.md in the main project repository). Reached as
`Rudesheim MobileLab Theodolite Application`.

`start` builds the Model, opens the landscape View (`ViewLandscapeTheodoliteMobileLabRudesheim`,
note/ios-triangulation-app.md section 2.2 / NocoDB Sections 項番FD §2.2), and wires the two
together with `SpecBuilderTheodoliteMobileLabRudesheim class>>#bindModel:toView:` (項番FL). The
portrait View (項番FD §2.1) and the ObjC-bridge location/heading sourcing (項番FJ §8 item 4) are
separate, not-yet-built work.
"
Class {
	#name : 'ApplicationTheodoliteMobileLabRudesheim',
	#superclass : 'SpApplication',
	#instVars : [
		'model'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'private' }
ApplicationTheodoliteMobileLabRudesheim >> defaultModel [
	^ Rudesheim MobileLab Theodolite Model new.
]

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheim >> model [
	^ model
		ifNil:
		[
			model := self defaultModel.
		].
]

{ #category : 'starting' }
ApplicationTheodoliteMobileLabRudesheim >> start [
	|
		namespace
		view
		window
	|

	namespace := Rudesheim MobileLab Theodolite.
	view := namespace ViewLandscape new.

	window :=
		(
			view
				open
		)
			title:		'Theodolite';
			yourself.

	self
		registerWindow:	window.

	namespace SpecBuilder
		bindModel:	self model
		toView:		view.
]
