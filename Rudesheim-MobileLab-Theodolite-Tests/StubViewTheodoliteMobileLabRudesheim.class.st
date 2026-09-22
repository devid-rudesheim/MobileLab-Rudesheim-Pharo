"
A StubViewTheodoliteMobileLabRudesheim is a minimal stand-in for the (not-yet-built)
portrait/landscape View presenters, exposing exactly the widget protocol
SpecBuilderTheodoliteMobileLabRudesheim>>#bindModel:toView: needs: #progressLabel/#addressBar/
#warningLabel (each a real SpLabelPresenter, so Spec2-Transmission's #defaultInputPort works) and
#addLineButton/#removeLineButton/#openButton/#copyButton/#discardButton (each a real
SpButtonPresenter, so #action: works). Test-only; never opened as a window.
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
		'discardButton'
	],
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> addLineButton [
	^ addLineButton
		ifNil:
		[
			addLineButton := SpButtonPresenter new    application: self application;    yourself.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> addressBar [
	^ addressBar
		ifNil:
		[
			addressBar := SpLabelPresenter new    application: self application;    yourself.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> copyButton [
	^ copyButton
		ifNil:
		[
			copyButton := SpButtonPresenter new    application: self application;    yourself.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> discardButton [
	^ discardButton
		ifNil:
		[
			discardButton := SpButtonPresenter new    application: self application;    yourself.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> openButton [
	^ openButton
		ifNil:
		[
			openButton := SpButtonPresenter new    application: self application;    yourself.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> progressLabel [
	^ progressLabel
		ifNil:
		[
			progressLabel := SpLabelPresenter new    application: self application;    yourself.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> removeLineButton [
	^ removeLineButton
		ifNil:
		[
			removeLineButton := SpButtonPresenter new    application: self application;    yourself.
		].
]

{ #category : 'accessing' }
StubViewTheodoliteMobileLabRudesheim >> warningLabel [
	^ warningLabel
		ifNil:
		[
			warningLabel := SpLabelPresenter new    application: self application;    yourself.
		].
]
