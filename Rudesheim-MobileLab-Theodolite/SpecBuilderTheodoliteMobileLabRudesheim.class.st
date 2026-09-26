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

#addLineButton's action reads the current position/heading itself (via Rudesheim-MobileLab's
OS-dispatch mechanism, `Smalltalk os rudesheim location currentRay`; see MacOSLocationRudesheim's
comment for its own known limitation) rather than delegating that to
BearingLinesTheodoliteMobileLabRudesheim (see its own comment for why): `currentRay` blocks its
caller for up to ~50 seconds waiting on a CoreLocation delegate callback, so it runs on a TaskIt
background process (`#future`) instead of the UI process, with #addLineButton/#removeLineButton
both disabled for the duration via the local `setButtonsEnabled` block (`aBoolean ->` both buttons'
`#enabled:`) -- this button owns that whole fetch, so it is the natural (and only) place that can
also own disabling itself and its sibling button around it, which is why the fetch was not left
inside BearingLinesTheodoliteMobileLabRudesheim's own #push (now removed). The future's callbacks
run back on the UI process via `aView addLineButton defer:` (an SpPresenter, so this routes through
the app's own SpApplication/backend, unlike the UI-agnostic `UIManager default defer:`) -- #add: on
success, re-enabling both buttons via `setButtonsEnabled` either way. A location/heading failure
(timeout or otherwise) surfaces through the existing #warning mechanism (same as #add:'s own
near-parallel-line rejection) rather than a dialog, so there is no `on:do:` guard to open the
debugger for.

#openButton's action and the LaunchRequested handler below open each
mapURL through `Smalltalk os rudesheim launcher open:` rather than sending it a `ZnUrl`-side
#launch -- see OSLauncherRudesheim's comment for why that dispatch lives there instead.

#mapArea's drawBlock: re-renders from `aModel bearingLines` directly (like the transform blocks
above, not from whatever raw value Spec2-Transmission's port would hand it): it clears the canvas,
then asks RendererTheodoliteMobileLabRudesheim class>>#renderersFor:canvas: for a 0-or-1-element
array of ready renderers (it refits the visible bounds -- every origin plus the current
intersection point -- from scratch on every call, so the block itself never sees an intermediate
Rectangle) and, for each renderer, sends `aCanvas draw: (each renderer: renderer)` for both
RaysTheodoliteMobileLabRudesheim/MarkersTheodoliteMobileLabRudesheim classes -- their class-side
#renderer: builds the instance right there, as `#draw:`'s argument. AthensCanvas>>#draw:'s own
generic double-dispatch (`^ anObject drawOnAthensCanvas: self`, already provided by Athens, not
something this app defines) is exactly why both classes answer #drawOnAthensCanvas:. `aCanvas`
itself is not kept anywhere longer-lived than that one send, since it is only valid for the
duration of Athens' own paint callback. This is inlined here rather than behind a class-side
`Renderer class>>#drawBearingLines:on:` entry point because that method (like the
Renderer-instance-side #draw it used to call, before Rays/Markers existed) had exactly one
caller -- this block. #removeLineButton/#discardButton each explicitly send #redraw right after
mutating `aModel bearingLines`, since both do so synchronously; #addLineButton's own #redraw send
is inside its future's success callback instead, since that is the point its mutation actually
happens. Either way every accepted 'Add line' press (and every remove/discard) refits and repaints
the map; #openButton/#copyButton do not mutate the lines, so they do not redraw.
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
	|
		setButtonsEnabled
	|

	setButtonsEnabled :=
	[ :aBoolean |
			{
				aView addLineButton.
				aView removeLineButton
			}
				do:
				[ :each |
					each
						enabled:	aBoolean.
				].
		].

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
			|
				theodolite
			|

			theodolite := Rudesheim MobileLab Theodolite.
			aCanvas surface clear.

			(
				theodolite Renderer
					renderersFor:	aModel bearingLines
					canvas:	aCanvas
			)
				do:
				[ :renderer |
					{
						theodolite Rays.
						theodolite Markers
					}
						do:
						[ :each |
							aCanvas
								draw:
								(
									each
										renderer:	renderer
								).
						].
				].
		].

	aView addLineButton
		action:
		[
			setButtonsEnabled
				value:	false.

			[
				Smalltalk os rudesheim location currentRay.
			] future
				onSuccessDo:
				[ :aGRay |
					aView addLineButton
						defer:
						[
							aModel bearingLines
								add:	aGRay.

							aView mapArea redraw.

							setButtonsEnabled
								value:	true.
						].
				];
				onFailureDo:
				[ :anError |
					aView addLineButton
						defer:
						[
							aModel warning
								value:
								{
									anError messageText
								}.

							setButtonsEnabled
								value:	true.
						].
				].
		].

	aView removeLineButton
		action:
		[
			aModel bearingLines removeLast.
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
