"
A SpecBuilderTheodoliteMobileLabRudesheim wires a ModelTheodoliteMobileLabRudesheim to whichever
View (portrait or landscape SpPresenter) currently owns the window, per
note/ios-triangulation-app.md section 7.4 (NocoDB Sections 項番FL). Stateless: it exists only for
its class-side #bindModel:toView:, called once per View instance.

The View just needs to answer #progressLabel/#addressBar/#warningLabel (each an SpAbstractPresenter,
for the Spec2-Transmission read direction) and #addLineButton/#openButton/#copyButton/
#discardButton (each an SpButtonPresenter, for the write-direction action blocks).

`CLLocationManagerAgent`/`CLHeadingAgent` (current-location/true-heading sourcing over the ObjC
bridge, note/ios-triangulation-app.md section 8 item 4) are deliberately not implemented yet --
that is separate, iOS-only, and unverified-headless work. Referencing them here compiles fine
(they resolve once that work lands) but #addLineButton's action block cannot actually run until
then.
"
Class {
	#name : 'SpecBuilderTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'binding' }
SpecBuilderTheodoliteMobileLabRudesheim class >> bindModel: aModel toView: aView [
	(SpPresenterWithModel new model: aModel bearingLines)
		transmitTo: aView progressLabel
		transform: [ :lines |
			lines size printString , '/' , lines class maxSize printString , '本' ].

	(SpPresenterWithModel new model: aModel bearingLines)
		transmitTo: aView addressBar
		transform: [ :lines |
			lines mapURL
				ifEmpty: [ '' ]
				ifNotEmpty: [ :urls | urls first displayString ] ].

	(SpPresenterWithModel new model: aModel warning)
		transmitTo: aView warningLabel
		transform: [ :warnings |
			warnings
				ifEmpty: [ '' ]
				ifNotEmpty: [ :ws | ws first message ] ]
		postTransmission: [ :dest :origin :value |
			value isEmpty
				ifTrue: [ dest removeStyle: #warning ]
				ifFalse: [ dest addStyle: #warning ] ].

	aView addLineButton
		action:
			[ aModel
				addLineAt: CLLocationManagerAgent default currentLocation
				heading: CLHeadingAgent default trueHeading ].
	aView openButton
		action: [ aModel bearingLines mapURL do: [ :url | url launch ] ].
	aView copyButton
		action: [ aModel bearingLines mapURL do: [ :url | Clipboard clipboardText: url displayString ] ].
	aView discardButton
		action: [ aModel discardAll ].

	aModel bearingLines announcer
		when: LaunchRequestedTheodoliteMobileLabRudesheim
		do: [ aModel bearingLines mapURL do: [ :url | url launch ] ].
]