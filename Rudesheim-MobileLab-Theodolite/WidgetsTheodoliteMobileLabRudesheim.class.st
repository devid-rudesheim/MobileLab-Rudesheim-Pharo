"
A WidgetsTheodoliteMobileLabRudesheim holds the widget set shared by every Theodolite View
presenter regardless of orientation (portrait, 項番FD §2.1, and landscape,
ViewLandscapeTheodoliteMobileLabRudesheim, 項番FD §2.2 -- both show the same progress/address/
warning readouts and add/remove/open/copy/discard controls, only arranged differently). Reached
as `Rudesheim MobileLab Theodolite Widgets`.

It exists to satisfy exactly the widget protocol SpecBuilderTheodoliteMobileLabRudesheim>>
#bindModel:toView: needs: #progressLabel (a real SpLabelPresenter), #addressBar/#warningLabel
(each a real SpTextInputFieldPresenter, `beNotEditable` -- a read-only text box rather than a
label, so the user can select and copy the map URL or warning text to the clipboard), #mapArea
(a real SpAthensPresenter -- the self-drawn map, decision recorded in NocoDB Sections 項番GM,
rendered by RaysTheodoliteMobileLabRudesheim/MarkersTheodoliteMobileLabRudesheim) and
#addLineButton/#removeLineButton/
#openButton/#copyButton/#discardButton (each a real SpButtonPresenter showing a Pharo
`Smalltalk ui icons` icon instead of a text label -- add: #glamorousEdit, remove: #undo,
discard: #trash, copy: #smallCopy, open: #glamorousOpenFromUrl -- with the former label kept as
the button's tooltip via #help:). Each accessor lazily
builds its own widget via a matching #defaultXxx method
(~/.claude/CLAUDE.md's Smalltalk-specific default-to-lazy-initialization rule, also followed by
ModelTheodoliteMobileLabRudesheim's #bearingLines/#defaultBearingLines) -- callers never
construct these presenters themselves and pass them in; they only ever read the accessors.

Not itself a presenter, so it does not compose SpTPresenterBuilder (the trait `self newButton`/
`self newLabel` come from) -- it instead holds the `owner` (the View presenter it was built for,
#owner:) and builds each widget through `self owner newButton`/`self owner newLabel`, which
already resolves to that owning presenter's own trait-provided factory methods and wires the new
widget's SpAbstractPresenter-owner chain correctly (matching `SpPresenter>>#instantiate:`'s own
`aPresenterClass owner: self`, so there is no need to reimplement that wiring here). Each View
gets its own Widgets instance; the widget protocol is shared, not the widget instances.

`owner` has no sensible lazy default (there is no default presenter to build widgets under), so a
plain `new` would answer an unusable instance that raises `nil doesNotUnderstand:` on its very
first widget accessor -- TShouldntNewRudesheim blocks `new` outright instead, and class-side
#owner: (the sole constructor) uses `super new` to get past that guard.
"
Class {
	#name : 'WidgetsTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#traits : 'TShouldntNewRudesheim',
	#classTraits : 'TShouldntNewRudesheim classTrait',
	#instVars : [
		'owner',
		'progressLabel',
		'addressBar',
		'warningLabel',
		'addLineButton',
		'removeLineButton',
		'openButton',
		'copyButton',
		'discardButton',
		'mapArea'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'instance creation' }
WidgetsTheodoliteMobileLabRudesheim class >> owner: anOwningPresenter [
	^ super new
		owner:	anOwningPresenter;
		yourself.
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> addLineButton [
	^ addLineButton
		ifNil:
		[
			addLineButton := self defaultAddLineButton.
		].
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> addressBar [
	^ addressBar
		ifNil:
		[
			addressBar := self defaultAddressBar.
		].
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> copyButton [
	^ copyButton
		ifNil:
		[
			copyButton := self defaultCopyButton.
		].
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultAddLineButton [
	^ self owner newButton
		icon:	(Smalltalk ui icons iconNamed: #glamorousEdit);
		help:	'Add line';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultAddressBar [
	^ self owner newTextInput
		text:	'';
		beNotEditable;
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultCopyButton [
	^ self owner newButton
		icon:	(Smalltalk ui icons iconNamed: #smallCopy);
		help:	'Copy';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultDiscardButton [
	^ self owner newButton
		icon:	(Smalltalk ui icons iconNamed: #trash);
		help:	'Discard all';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultMapArea [
	^ self owner newAthens.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultOpenButton [
	^ self owner newButton
		icon:	(Smalltalk ui icons iconNamed: #glamorousOpenFromUrl);
		help:	'Open';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultProgressLabel [
	^ self owner newLabel
		label:	'';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultRemoveLineButton [
	^ self owner newButton
		icon:	(Smalltalk ui icons iconNamed: #undo);
		help:	'Remove line';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultWarningLabel [
	^ self owner newTextInput
		text:	'';
		beNotEditable;
		yourself.
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> discardButton [
	^ discardButton
		ifNil:
		[
			discardButton := self defaultDiscardButton.
		].
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> mapArea [
	^ mapArea
		ifNil:
		[
			mapArea := self defaultMapArea.
		].
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> openButton [
	^ openButton
		ifNil:
		[
			openButton := self defaultOpenButton.
		].
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> owner [
	^ owner.
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> owner: anOwningPresenter [
	owner := anOwningPresenter assertNotNilRudesheim.
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> progressLabel [
	^ progressLabel
		ifNil:
		[
			progressLabel := self defaultProgressLabel.
		].
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> removeLineButton [
	^ removeLineButton
		ifNil:
		[
			removeLineButton := self defaultRemoveLineButton.
		].
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> warningLabel [
	^ warningLabel
		ifNil:
		[
			warningLabel := self defaultWarningLabel.
		].
]
