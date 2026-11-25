"
An ImageExportMobileLabRudesheim prepares a Pharo image to be the image of an iospharo `Export as
App`, reached as `Rudesheim MobileLab Export Image`. The development image stays as it is; this is
run on a COPY of it (`tool/prepare-export-image.sh <worker>` copies `home/<worker>/images/ios/` to
`images/export/` and runs it) and the copy is saved with the app already running in the World, so
the exported app shows the app from its first frame: no Welcome window, no logo, no menubar and no
seconds of empty desktop while a startup script opens the app.

`prepareFor: aTargetTExportableMobileLabRudesheim extent: anExtentPoint` (the target is the app's
namespace class, e.g. `Rudesheim MobileLab Theodolite`, whose `application` must answer the
class-side `isRunning` and `openAsStartup`) hides Pharo's development chrome, gives the World the
device's extent in points (`anExtentPoint`, e.g. `402@874` for an iPhone 16/17 Pro; a headless desktop
World is 240@120 and the app would build its landscape View for that), opens the app, and registers
this class with the SessionManager. It does not save: the caller does, with
`Smalltalk snapshot: true andQuit: true`. Running it again on a prepared image changes nothing (the
chrome flags are set again, the running app is kept, the SessionManager registration is replaced).

IRREVERSIBLE, like the World ScreenPolicy it uses: never run it in a development image.

What does not survive an image restart, and what #startUp: therefore does when the image starts:
- every SpAthensMorph (Theodolite's map) holds an AthensCairoSurface whose native handle is invalid
  in the new session (`AthensCairoSurface>>#checkSession`); the surface is dropped so the next draw
  creates a new one, and a draw error already recorded by a morph is cleared. SpAthensMorph has no
  API for this, hence `instVarNamed:put:`.
- the World is the device's size by then, not the one saved: every morph of the World is set to the
  World's bounds again, on the UI process (`defer:`).
Nothing else of Theodolite needs re-arming: it keeps no timer, and a location is asked for by the
'Add line' button on demand (a TaskIt task started then).

A rotation of the device is not followed (nothing sends the World's new size here); see NocoDB
Documents 13 Sections HL.
"
Class {
	#name : 'ImageExportMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Export',
	#package : 'Rudesheim-MobileLab',
	#tag : 'Export'
}

{ #category : 'preparing' }
ImageExportMobileLabRudesheim class >> hideDevelopmentChrome [
	TaskbarMorph
		showTaskbar:	false.

	MenubarMorph
		showMenubar:	false.

	WorldState
		desktopMenuPragmaKeyword:	''.
]

{ #category : 'preparing' }
ImageExportMobileLabRudesheim class >> prepareFor: aTargetTExportableMobileLabRudesheim
extent: anExtentPoint [
	self hideDevelopmentChrome.

	World
		bounds:
		(
			0 @ 0
				extent:	anExtentPoint
		).

	aTargetTExportableMobileLabRudesheim application isRunning
		ifFalse:
		[
			aTargetTExportableMobileLabRudesheim application openAsStartup.
		].

	self register.
	^ World.
]

{ #category : 'starting' }
ImageExportMobileLabRudesheim class >> refitMorphsOf: aWorldMorph [
	aWorldMorph submorphs
		do:
		[ :aMorph |
			aMorph
				bounds:	aWorldMorph bounds.
		].
]

{ #category : 'preparing' }
ImageExportMobileLabRudesheim class >> register [
	(
		SessionManager default
			hasRegistered:	self name
	)
		ifTrue:
		[
			SessionManager default
				unregisterClassNamed:	self name.
		].

	SessionManager default
		registerSystemClassNamed:	self name.
]

{ #category : 'starting' }
ImageExportMobileLabRudesheim class >> resetSurfaceOf: aSpAthensMorph [
	aSpAthensMorph
		instVarNamed:	#surface
		put:	nil.

	(
		aSpAthensMorph
			hasProperty:	#errorOnDraw
	)
		ifTrue:
		[
			aSpAthensMorph resumeAfterDrawError.
		].

	aSpAthensMorph changed.
]

{ #category : 'starting' }
ImageExportMobileLabRudesheim class >> startUp: aBoolean [
	aBoolean
		ifFalse:
		[
			^ self.
		].

	SpAthensMorph allInstances
		do:
		[ :aMorph |
			self
				resetSurfaceOf:	aMorph.
		].

	UIManager default
		defer:
		[
			self
				refitMorphsOf:	World.
		].
]
