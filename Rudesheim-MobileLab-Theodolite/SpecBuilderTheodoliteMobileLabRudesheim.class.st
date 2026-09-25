"
A SpecBuilderTheodoliteMobileLabRudesheim wires a ModelTheodoliteMobileLabRudesheim to whichever
object exposes the widget protocol below -- in practice a View's `widgets`
(WidgetsTheodoliteMobileLabRudesheim, shared by both orientations; ApplicationTheodoliteMobileLabRudesheim>>
#start passes `view widgets`, not the View itself), since the View presenter (portrait or landscape)
only arranges those widgets and does not answer the protocol directly. Per note/ios-triangulation-app.md
section 7.4 (NocoDB Sections 項番FL). Stateless: it exists only for its class-side
#bindModel:toView:, called once per View instance.

`toView:` just needs to answer #progressLabel/#addressBar/#warningLabel (each an
SpAbstractPresenter, for the Spec2-Transmission read direction), #mapArea (an SpAthensPresenter,
the self-drawn map -- NocoDB Sections 項番GM) and #addLineButton/#removeLineButton/#openButton/
#copyButton/#discardButton (each an SpButtonPresenter, for the write-direction action blocks).

#addLineButton's action is just `aModel bearingLines push` -- sourcing the current position/heading
is BearingLinesTheodoliteMobileLabRudesheim's own concern (via Rudesheim-MobileLab's OS-dispatch
mechanism, `Smalltalk os rudesheim location currentRay`; see MacOSLocationRudesheim's comment for
its own known limitation). #openButton's action and the LaunchRequested handler below open each
mapURL through `Smalltalk os rudesheim launcher open:` rather than sending it a `ZnUrl`-side
#launch -- see OSLauncherRudesheim's comment for why that dispatch lives there instead.

#mapArea's drawBlock: re-renders from `aModel bearingLines` directly (like the transform blocks
above, not from whatever raw value Spec2-Transmission's port would hand it), via
MapDrawingTheodoliteMobileLabRudesheim -- which refits the visible bounds (every origin plus the
current intersection point) from scratch on every call. #addLineButton/#removeLineButton/
#discardButton each explicitly send #redraw after mutating `aModel bearingLines`, so every 'Add
line' press (and every remove/discard) refits and repaints the map; #openButton/#copyButton do not
mutate the lines, so they do not redraw.
"
Class {
	#name : 'SpecBuilderTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'binding' }
SpecBuilderTheodoliteMobileLabRudesheim class >> bindModel: aModel
toView: aView [
	"The transform blocks below close over aModel and re-derive everything from it directly,
	rather than trusting the raw value SpPresenterWithModel's port hands them (that value is
	whatever the underlying NewValueHolder is holding right now -- a plain OrderedCollection or
	Array, not the richer BearingLinesTheodoliteMobileLabRudesheim/warning holder itself)."
	(
		SpPresenterWithModel new
			model:	aModel bearingLines
	)
		transmitTo:	aView progressLabel
		transform:
		[ :ignored |
			aModel bearingLines size printString , '/' , aModel bearingLines class maxSize printString , ' lines'.
		].

	(
		SpPresenterWithModel new
			model:	aModel bearingLines
	)
		transmitTo:	aView addressBar
		transform:
		[ :ignored |
			aModel bearingLines mapURL
				ifEmpty:
				[
					''.
				]
				ifNotEmpty:
				[ :urls |
					urls first displayString.
				].
		].

	(
		SpPresenterWithModel new
			model:	aModel warning
	)
		transmitTo:	aView warningLabel
		transform:
		[ :ignored |
			aModel warning value
				ifEmpty:
				[
					''.
				]
				ifNotEmpty:
				[ :ws |
					ws first.
				].
		]
		postTransmission:
		[ :dest :origin :value |
			value
				ifEmpty:
				[
					dest
						removeStyle:	#warning.
				]
				ifNotEmpty:
				[
					dest
						addStyle:	#warning.
				].
		].

	aView mapArea
		drawBlock:
		[ :aCanvas |
			Rudesheim MobileLab Theodolite MapDrawing
				drawBearingLines:	aModel bearingLines
				extent:	aView mapArea surfaceExtent
				on:	aCanvas.
		].

	aView addLineButton
		action:
		[
			aModel bearingLines push.
			aView mapArea redraw.
		].

	aView removeLineButton
		action:
		[
			aModel bearingLines pop.
			aView mapArea redraw.
		].

	aView openButton
		action:
		[
			aModel bearingLines mapURL
				do:
				[ :url |
					Smalltalk os rudesheim launcher
						open:	url.
				].
		].

	aView copyButton
		action:
		[
			aModel bearingLines mapURL
				do:
				[ :url |
					Clipboard
						clipboardText:	url displayString.
				].
		].

	aView discardButton
		action:
		[
			aModel discardAll.
			aView mapArea redraw.
		].

	aModel bearingLines announcer
		when:	Rudesheim MobileLab Theodolite LaunchRequested
		do:
		[
			aModel bearingLines mapURL
				do:
				[ :url |
					Smalltalk os rudesheim launcher
						open:	url.
				].
		]
		for:	aView.
]
