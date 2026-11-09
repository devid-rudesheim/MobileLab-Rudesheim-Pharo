"
A StubViewTheodoliteMobileLabRudesheim is a minimal stand-in for the (not-yet-built)
portrait View presenter, exposing exactly the widget protocol
SpecBuilderTheodoliteMobileLabRudesheim>>#bindModel:toView: needs: #progressLabel/#addressBar/
#warningLabel (each a real SpLabelPresenter, so Spec2-Transmission's #defaultInputPort works),
#mapArea (a real SpAthensPresenter, so #drawBlock:/#redraw/#surfaceExtent work) and
#addLineButton/#removeLineButton/#openButton/#copyButton/#discardButton (each a real
SpButtonPresenter, so #action: works). Test-only; never opened as a window.

Each accessor lazily builds its own widget via a matching #defaultXxx method
(~/.claude/CLAUDE.md's Smalltalk-specific default-to-lazy-initialization rule), same as
ViewLandscapeTheodoliteMobileLabRudesheim's real landscape View presenter.
"
Class {
	#name : 'StubViewTheodoliteMobileLabRudesheim',
	#superclass : 'SpPresenter',
	#instVars : [
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
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> addLineButton [
	^ addLineButton
		ifNil:
		[
			addLineButton := self defaultAddLineButton.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> addressBar [
	^ addressBar
		ifNil:
		[
			addressBar := self defaultAddressBar.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> copyButton [
	^ copyButton
		ifNil:
		[
			copyButton := self defaultCopyButton.
		].
]

{ #category : 'private' }
StubViewTheodoliteMobileLabRudesheim >> defaultAddLineButton [
	^ SpButtonPresenter new
		application:	self application;
		yourself.
]

{ #category : 'private' }
StubViewTheodoliteMobileLabRudesheim >> defaultAddressBar [
	^ SpLabelPresenter new
		application:	self application;
		yourself.
]

{ #category : 'private' }
StubViewTheodoliteMobileLabRudesheim >> defaultCopyButton [
	^ SpButtonPresenter new
		application:	self application;
		yourself.
]

{ #category : 'private' }
StubViewTheodoliteMobileLabRudesheim >> defaultDiscardButton [
	^ SpButtonPresenter new
		application:	self application;
		yourself.
]

{ #category : 'private' }
StubViewTheodoliteMobileLabRudesheim >> defaultMapArea [
	^ SpAthensPresenter new
		application:	self application;
		yourself.
]

{ #category : 'private' }
StubViewTheodoliteMobileLabRudesheim >> defaultOpenButton [
	^ SpButtonPresenter new
		application:	self application;
		yourself.
]

{ #category : 'private' }
StubViewTheodoliteMobileLabRudesheim >> defaultProgressLabel [
	^ SpLabelPresenter new
		application:	self application;
		yourself.
]

{ #category : 'private' }
StubViewTheodoliteMobileLabRudesheim >> defaultRemoveLineButton [
	^ SpButtonPresenter new
		application:	self application;
		yourself.
]

{ #category : 'private' }
StubViewTheodoliteMobileLabRudesheim >> defaultWarningLabel [
	^ SpLabelPresenter new
		application:	self application;
		yourself.
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> discardButton [
	^ discardButton
		ifNil:
		[
			discardButton := self defaultDiscardButton.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> mapArea [
	^ mapArea
		ifNil:
		[
			mapArea := self defaultMapArea.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> openButton [
	^ openButton
		ifNil:
		[
			openButton := self defaultOpenButton.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> progressLabel [
	^ progressLabel
		ifNil:
		[
			progressLabel := self defaultProgressLabel.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> removeLineButton [
	^ removeLineButton
		ifNil:
		[
			removeLineButton := self defaultRemoveLineButton.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> warningLabel [
	^ warningLabel
		ifNil:
		[
			warningLabel := self defaultWarningLabel.
		].
]
