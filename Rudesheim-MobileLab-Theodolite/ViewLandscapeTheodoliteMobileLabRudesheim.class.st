"
A ViewLandscapeTheodoliteMobileLabRudesheim is Theodolite's landscape-orientation View presenter
(note/ios-triangulation-app.md section 2.2 / NocoDB Sections 項番FD §2.2). Reached as
`Rudesheim MobileLab Theodolite ViewLandscape`.

It exists to satisfy exactly the widget protocol SpecBuilderTheodoliteMobileLabRudesheim>>
#bindModel:toView: needs (see that class's comment and StubViewTheodoliteMobileLabRudesheim's,
which mirrors the same protocol for tests): #progressLabel/#addressBar/#warningLabel (each a real
SpLabelPresenter) and #addLineButton/#removeLineButton/#openButton/#copyButton/#discardButton
(each a real SpButtonPresenter). Each accessor lazily builds its own widget via a matching
#defaultXxx method (~/.claude/CLAUDE.md's Smalltalk-specific default-to-lazy-initialization rule,
also followed by ModelTheodoliteMobileLabRudesheim's #bearingLines/#defaultBearingLines) --
callers (in particular ApplicationTheodoliteMobileLabRudesheim>>#start) never construct these
presenters themselves and pass them in; they only ever read the accessors.

#defaultLayout arranges them into the landscape structure: a full-width, fixed-height top row
(discard/address/open/copy) and a bottom row with a variable-width map placeholder (self-drawn
map display is separate, not-yet-built work) plus a fixed-width column (add/remove/progress/
warning). The portrait layout (項番FD §2.1) is separate, not-yet-built work.
"
Class {
	#name : 'ViewLandscapeTheodoliteMobileLabRudesheim',
	#superclass : 'SpPresenter',
	#instVars : [
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

{ #category : 'accessing' }
ViewLandscapeTheodoliteMobileLabRudesheim >> addLineButton [
	^ addLineButton
		ifNil:
		[
			addLineButton := self defaultAddLineButton.
		].
]

{ #category : 'accessing' }
ViewLandscapeTheodoliteMobileLabRudesheim >> addressBar [
	^ addressBar
		ifNil:
		[
			addressBar := self defaultAddressBar.
		].
]

{ #category : 'accessing' }
ViewLandscapeTheodoliteMobileLabRudesheim >> copyButton [
	^ copyButton
		ifNil:
		[
			copyButton := self defaultCopyButton.
		].
]

{ #category : 'private' }
ViewLandscapeTheodoliteMobileLabRudesheim >> defaultAddLineButton [
	^ self newButton
		label:	'Add line';
		yourself.
]

{ #category : 'private' }
ViewLandscapeTheodoliteMobileLabRudesheim >> defaultAddressBar [
	^ self newLabel
		label:	'';
		yourself.
]

{ #category : 'private' }
ViewLandscapeTheodoliteMobileLabRudesheim >> defaultCopyButton [
	^ self newButton
		label:	'Copy';
		yourself.
]

{ #category : 'private' }
ViewLandscapeTheodoliteMobileLabRudesheim >> defaultDiscardButton [
	^ self newButton
		label:	'Discard all';
		yourself.
]

{ #category : 'private' }
ViewLandscapeTheodoliteMobileLabRudesheim >> defaultOpenButton [
	^ self newButton
		label:	'Open';
		yourself.
]

{ #category : 'private' }
ViewLandscapeTheodoliteMobileLabRudesheim >> defaultProgressLabel [
	^ self newLabel
		label:	'';
		yourself.
]

{ #category : 'private' }
ViewLandscapeTheodoliteMobileLabRudesheim >> defaultRemoveLineButton [
	^ self newButton
		label:	'Remove line';
		yourself.
]

{ #category : 'private' }
ViewLandscapeTheodoliteMobileLabRudesheim >> defaultWarningLabel [
	^ self newLabel
		label:	'';
		yourself.
]

{ #category : 'layout' }
ViewLandscapeTheodoliteMobileLabRudesheim >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add:
		(
			SpBoxLayout newLeftToRight
				add:	self discardButton expand: false;
				add:	self addressBar expand: true;
				add:	self openButton expand: false;
				add:	self copyButton expand: false;
				yourself
		)
		expand:	false;

		add:
		(
			SpBoxLayout newLeftToRight
				add:
				(
					self newLabel
						label:	'Map (self-drawn, not yet implemented)';
						yourself
				)
				expand:	true;

				add:
				(
					SpBoxLayout newTopToBottom
						add:	self addLineButton expand: false;
						add:	self removeLineButton expand: false;
						add:	self progressLabel expand: false;
						add:	self warningLabel expand: false;
						yourself
				)
				expand:	false;

				yourself
		)
		expand:	true;

		yourself.
]

{ #category : 'accessing' }
ViewLandscapeTheodoliteMobileLabRudesheim >> discardButton [
	^ discardButton
		ifNil:
		[
			discardButton := self defaultDiscardButton.
		].
]

{ #category : 'accessing' }
ViewLandscapeTheodoliteMobileLabRudesheim >> openButton [
	^ openButton
		ifNil:
		[
			openButton := self defaultOpenButton.
		].
]

{ #category : 'accessing' }
ViewLandscapeTheodoliteMobileLabRudesheim >> progressLabel [
	^ progressLabel
		ifNil:
		[
			progressLabel := self defaultProgressLabel.
		].
]

{ #category : 'accessing' }
ViewLandscapeTheodoliteMobileLabRudesheim >> removeLineButton [
	^ removeLineButton
		ifNil:
		[
			removeLineButton := self defaultRemoveLineButton.
		].
]

{ #category : 'accessing' }
ViewLandscapeTheodoliteMobileLabRudesheim >> warningLabel [
	^ warningLabel
		ifNil:
		[
			warningLabel := self defaultWarningLabel.
		].
]
