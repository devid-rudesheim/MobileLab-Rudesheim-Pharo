"
An ApplicationTheodoliteMobileLabRudesheim is the SpApplication for Theodolite, the iOS
bearing-line triangulation prototype (resection from three recorded bearings, see
note/ios-triangulation-app.md in the main project repository). Reached as
`Rudesheim MobileLab Theodolite Application`.

`start` builds the Model, opens the landscape View (`ViewLandscapeTheodoliteMobileLabRudesheim`,
note/ios-triangulation-app.md section 2.2 / NocoDB Sections 項番FD §2.2, lazily via
#viewLandscape/#defaultViewLandscape -- same pattern as #model, and exposed for the same reason:
so a test can grab `target viewLandscape` before calling `target start` and assert on it
afterward), and wires the Model to the View's `widgets` (a WidgetsTheodoliteMobileLabRudesheim,
holding the actual widget protocol SpecBuilder needs -- the View itself only arranges them) with
`SpecBuilderTheodoliteMobileLabRudesheim class>>#bindModel:toView:` (項番FL). The portrait View
(項番FD §2.1) and the ObjC-bridge location/heading sourcing (項番FJ §8 item 4) are separate,
not-yet-built work.

`menuLabel` is this app's display name in the `MobileLab` World Menu item
(`WorldMenuMobileLabRudesheim class>>#menuOn:` discovers every `Rudesheim MobileLab * Application`
class and reads its `menuLabel`).
"
Class {
	#name : 'ApplicationTheodoliteMobileLabRudesheim',
	#superclass : 'SpApplication',
	#instVars : [
		'model',
		'viewLandscape'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheim class >> menuLabel [
	^ 'Theodolite'.
]

{ #category : 'private' }
ApplicationTheodoliteMobileLabRudesheim >> defaultModel [
	^ Rudesheim MobileLab Theodolite Model new.
]

{ #category : 'private' }
ApplicationTheodoliteMobileLabRudesheim >> defaultViewLandscape [
	^ Rudesheim MobileLab Theodolite ViewLandscape new.
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
		view
		window
	|

	view := self viewLandscape.
	window := view open    title: 'Theodolite';    yourself.

	self
		registerWindow:	window.

	Rudesheim MobileLab Theodolite SpecBuilder
		bindModel:	self model
		toView:	view widgets.
]

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheim >> viewLandscape [
	^ viewLandscape
		ifNil:
		[
			viewLandscape := self defaultViewLandscape.
		].
]
