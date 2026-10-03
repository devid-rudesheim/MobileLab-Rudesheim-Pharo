"
An ApplicationTheodoliteMobileLabRudesheim is the SpApplication for Theodolite, the iOS
bearing-line triangulation prototype (resection from three recorded bearings, see
note/ios-triangulation-app.md in the main project repository). Reached as
`Rudesheim MobileLab Theodolite Application`.

`start` builds the Model, opens whichever View suits the display's orientation (#viewFor: -- the
portrait View, `ViewPortraitTheodoliteMobileLabRudesheim`, when the display is taller than wide,
otherwise the landscape View, `ViewLandscapeTheodoliteMobileLabRudesheim`; note/ios-triangulation-app.md
sections 2.1/2.2 / NocoDB Sections 項番FD), and wires the one Model to the `widgets` (a
WidgetsTheodoliteMobileLabRudesheim, holding the actual widget protocol SpecBuilder needs -- the
View itself only arranges them) of *both* Views with
`SpecBuilderTheodoliteMobileLabRudesheim class>>#bindModel:toView:` (項番FL), so the recorded
bearing lines are shared whichever View is showing. Each View is built lazily via
#viewPortrait/#viewLandscape (and their #defaultXxx) -- same pattern as #model, and exposed for
the same reason: so a test can grab `target viewPortrait` before calling `target start` and
assert on it afterward. How much of the screen the opened View takes is the `screenPolicy` (a `Rudesheim MobileLab
ScreenPolicy` object: `Window`, the default, opens an ordinary window; `World` opens the View as the
Pharo World itself, for a native-looking app -- irreversible, see WorldScreenPolicyMobileLabRudesheim),
given with `screenPolicy:` before `run`, e.g.
`mobileLib Theodolite Application new screenPolicy: mobileLib ScreenPolicy World; run`.
Swapping Views live when the device rotates (項番FI §7.1 (b)) and the
ObjC-bridge location/heading sourcing (項番FJ §8 item 4) are separate, not-yet-built work.

`menuLabel` is this app's display name in the `MobileLab` World Menu item
(`WorldMenuMobileLabRudesheim class>>#menuOn:` discovers every `Rudesheim MobileLab * Application`
class and reads its `menuLabel`).
"
Class {
	#name : 'ApplicationTheodoliteMobileLabRudesheim',
	#superclass : 'SpApplication',
	#instVars : [
		'model',
		'viewLandscape',
		'viewPortrait',
		'screenPolicy'
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
ApplicationTheodoliteMobileLabRudesheim >> defaultScreenPolicy [
	^ Rudesheim MobileLab ScreenPolicy Window.
]

{ #category : 'private' }
ApplicationTheodoliteMobileLabRudesheim >> defaultViewLandscape [
	^ Rudesheim MobileLab Theodolite ViewLandscape new.
]

{ #category : 'private' }
ApplicationTheodoliteMobileLabRudesheim >> defaultViewPortrait [
	^ Rudesheim MobileLab Theodolite ViewPortrait new.
]

{ #category : 'private' }
ApplicationTheodoliteMobileLabRudesheim >> defaultWindowExtent [
	^ World extent.
]

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheim >> model [
	^ model
		ifNil:
		[
			model := self defaultModel.
		].
]

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheim >> screenPolicy [
	^ screenPolicy
		ifNil:
		[
			screenPolicy := self defaultScreenPolicy.
		].
]

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheim >> screenPolicy: aScreenPolicyMobileLabRudesheim [
	screenPolicy := aScreenPolicyMobileLabRudesheim.
]

{ #category : 'starting' }
ApplicationTheodoliteMobileLabRudesheim >> start [
	|
		view
		window
	|

	view :=
		self
			viewFor:	self defaultWindowExtent.

	window :=
		self screenPolicy
			open:	view
			titled:	'Theodolite'.

	self
		registerWindow:	window.

	Rudesheim MobileLab Theodolite SpecBuilder
		bindModel:	self model
		toView:	self viewLandscape widgets.

	Rudesheim MobileLab Theodolite SpecBuilder
		bindModel:	self model
		toView:	self viewPortrait widgets.
]

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheim >> viewFor: aPoint [
	aPoint y > aPoint x
		ifTrue:
		[
			^ self viewPortrait.
		].

	^ self viewLandscape.
]

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheim >> viewLandscape [
	^ viewLandscape
		ifNil:
		[
			viewLandscape := self defaultViewLandscape.
		].
]

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheim >> viewPortrait [
	^ viewPortrait
		ifNil:
		[
			viewPortrait := self defaultViewPortrait.
		].
]
