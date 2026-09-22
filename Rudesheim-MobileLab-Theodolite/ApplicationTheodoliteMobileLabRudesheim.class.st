"
An ApplicationTheodoliteMobileLabRudesheim is the SpApplication for Theodolite, the iOS
bearing-line triangulation prototype (resection from three recorded bearings, see
note/ios-triangulation-app.md in the main project repository). Reached as
`Rudesheim MobileLab Theodolite Application`.

`start` builds the Model and, for now, the landscape layout only (note/ios-triangulation-app.md
section 2.2 / NocoDB Sections 項番FD §2.2), wired directly in place -- no dedicated SpPresenter
subclass, the same one-off-anonymous-presenter style as `ApplicationDownloaderRudesheim>>#start`
(`self newPresenter: SpPresenter` + `in: [ :root | ... root openWithLayout: ... ]`). The portrait
layout (項番FD §2.1) and the ObjC-bridge location/heading sourcing (項番FJ §8 item 4) are separate,
not-yet-built work. `SpecBuilderTheodoliteMobileLabRudesheim`'s `bindModel:toView:` (項番FL) targets
a future named View presenter exposing named accessors -- this inline landscape build wires the
same Model directly against the ad hoc widgets instead, so it is not used here.
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
	self
		registerWindow:
		(
			(
				(
					self
						newPresenter:	SpPresenter
				)
				in:
				[ :root |
					|
						window
						progressLabel
						addressBar
						warningLabel
						updateBearingLines
						updateWarning
					|

					window :=
					root
						openWithLayout:
						(
							root newBoxLayoutTopToBottom
								add:
								(
									root newBoxLayoutLeftToRight
										add:
										(
											root newButton
												label:	'Discard all';
												action:	[ self model discardAll ];
												yourself
										)
										expand:	false;

										add:
										(
											addressBar :=
												root newLabel
													label:	'';
													yourself
										)
										expand:	true;

										add:
										(
											root newButton
												label:	'Open';
												action:
												[
													self model bearingLines mapURL
														do:	#launch.
												];
												yourself
										)
										expand:	false;

										add:
										(
											root newButton
												label:	'Copy';
												action:
												[
													self model bearingLines mapURL
														do:
														[ :url |
															Clipboard
																clipboardText:	url displayString.
														].
												];
												yourself
										)
										expand:	false;

										yourself
								)
								expand:	false;

								add:
								(
									root newBoxLayoutLeftToRight
										add:
										(
											root newLabel
												label:	'Map (self-drawn, not yet implemented)';
												yourself
										)
										expand:	true;

										add:
										(
											root newBoxLayoutTopToBottom
												add:
												(
													root newButton
														label:	'Add line';
														action:	[ self model bearingLines push ];
														yourself
												)
												expand:	false;

												add:
												(
													root newButton
														label:	'Remove line';
														action:	[ self model bearingLines pop ];
														yourself
												)
												expand:	false;

												add:
												(
													progressLabel :=
														root newLabel
															label:	'';
															yourself
												)
												expand:	false;

												add:
												(
													warningLabel :=
														root newLabel
															label:	'';
															yourself
												)
												expand:	false;

												yourself
										)
										expand:	false;

										yourself
								)
								expand:	true;

								yourself
						).

					updateBearingLines :=
					[
						progressLabel
							label:	self model bearingLines size printString , '/' , self model bearingLines class maxSize printString , ' lines'.

						addressBar
							label:
							(
								self model bearingLines mapURL
									ifEmpty:	[ '' ]
									ifNotEmpty:	[ :urls | urls first displayString ]
							).
					].

					updateWarning :=
					[
						warningLabel
							label:
							(
								self model warning value
									ifEmpty:	[ '' ]
									ifNotEmpty:	[ :ws | ws first ]
							).
					].

					updateBearingLines value.
					updateWarning value.

					self model bearingLines
						whenChangedDo:	updateBearingLines.

					self model warning
						whenChangedDo:	updateWarning.

					self model bearingLines announcer
						when:	Rudesheim MobileLab Theodolite LaunchRequested
						do:	[ self model bearingLines mapURL do: #launch ]
						for:	window.

					window.
				]
			)
				title:		'Theodolite';
				yourself
		).
]
