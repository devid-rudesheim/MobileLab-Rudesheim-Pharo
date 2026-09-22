"
A WidgetsTheodoliteMobileLabRudesheim holds the widget set shared by every Theodolite View
presenter regardless of orientation (portrait, 項番FD §2.1, and landscape,
ViewLandscapeTheodoliteMobileLabRudesheim, 項番FD §2.2 -- both show the same progress/address/
warning readouts and add/remove/open/copy/discard controls, only arranged differently). Reached
as `Rudesheim MobileLab Theodolite Widgets`.

It exists to satisfy exactly the widget protocol SpecBuilderTheodoliteMobileLabRudesheim>>
#bindModel:toView: needs: #progressLabel/#addressBar/#warningLabel (each a real SpLabelPresenter)
and #addLineButton/#removeLineButton/#openButton/#copyButton/#discardButton (each a real
SpButtonPresenter). Each accessor lazily builds its own widget via a matching #defaultXxx method
(~/.claude/CLAUDE.md's Smalltalk-specific default-to-lazy-initialization rule, also followed by
ModelTheodoliteMobileLabRudesheim's #bearingLines/#defaultBearingLines) -- callers never
construct these presenters themselves and pass them in; they only ever read the accessors.

Not itself a presenter (it has no layout of its own), so widget construction goes through
`SpButtonPresenter new application: self application; ...`/`SpLabelPresenter new application:
self application; ...` directly rather than through `self newButton`/`self newLabel` -- it needs
an owning `application` (#application:), supplied by whichever View presenter builds one for its
own layout (each View gets its own Widgets instance; the widget protocol is shared, not the
widget instances).
"
Class {
	#name : 'WidgetsTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'application',
		'progressLabel',
		'addressBar',
		'warningLabel',
		'addLineButton',
		'removeLineButton',
		'openButton',
		'copyButton',
		'discardButton'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'instance creation' }
WidgetsTheodoliteMobileLabRudesheim class >> application: anApplication [
	^ self new
		application:	anApplication;
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
WidgetsTheodoliteMobileLabRudesheim >> application [
	^ application.
]

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheim >> application: anApplication [
	application := anApplication.
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
	^ SpButtonPresenter new
		application:	self application;
		label:	'Add line';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultAddressBar [
	^ SpLabelPresenter new
		application:	self application;
		label:	'';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultCopyButton [
	^ SpButtonPresenter new
		application:	self application;
		label:	'Copy';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultDiscardButton [
	^ SpButtonPresenter new
		application:	self application;
		label:	'Discard all';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultOpenButton [
	^ SpButtonPresenter new
		application:	self application;
		label:	'Open';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultProgressLabel [
	^ SpLabelPresenter new
		application:	self application;
		label:	'';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultRemoveLineButton [
	^ SpButtonPresenter new
		application:	self application;
		label:	'Remove line';
		yourself.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheim >> defaultWarningLabel [
	^ SpLabelPresenter new
		application:	self application;
		label:	'';
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
WidgetsTheodoliteMobileLabRudesheim >> openButton [
	^ openButton
		ifNil:
		[
			openButton := self defaultOpenButton.
		].
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
