"
A ViewPortraitTheodoliteMobileLabRudesheim is Theodolite's portrait-orientation View presenter
(note/ios-triangulation-app.md section 2.1 / NocoDB Sections 項番FD §2.1). Reached as
`Rudesheim MobileLab Theodolite ViewPortrait`.

Like ViewLandscapeTheodoliteMobileLabRudesheim, it only arranges the widgets it gets from its
`widgets` (a WidgetsTheodoliteMobileLabRudesheim, the widget set shared by both orientations) into
the portrait structure, top to bottom: the fixed-height rarely-used row (discard/address/open/copy)
-- the same top row the landscape View has, so the address readout is always the topmost thing --
then the variable-height self-drawn map area (`widgets mapArea`, 項番GM), then the controls
stacked vertically as three full-width fixed-height rows in the order progress, remove, add (the
horizontal add/remove/progress order mirrored left-right, then each part given its own row, left
part on top), and finally `widgets warningLabel` alone as a full-width, fixed-height row pinned to
the bottom of the window, below everything else -- per the layout decision recorded in NocoDB
Sections 項番GO. `add` is the primary action, so its row is three times as tall as a standard
button (`self buttonHeight * 3` in #defaultLayout) -- a bigger tap target. It does not itself answer #progressLabel/#addressBar/etc -- callers that need the
widget protocol SpecBuilderTheodoliteMobileLabRudesheim>>#bindModel:toView: needs go through
`self widgets` directly.
"
Class {
	#name : 'ViewPortraitTheodoliteMobileLabRudesheim',
	#superclass : 'SpPresenter',
	#instVars : [
		'widgets'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'accessing' }
ViewPortraitTheodoliteMobileLabRudesheim class >> buttonHeight [
	"The height Spec2 gives a standard one-line button with the default font (measured: 28)."
	^ 28.
]

{ #category : 'accessing' }
ViewPortraitTheodoliteMobileLabRudesheim >> buttonHeight [
	^ self class buttonHeight.
]

{ #category : 'layout' }
ViewPortraitTheodoliteMobileLabRudesheim >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add:
		(
			SpBoxLayout newLeftToRight
				add:	self widgets discardButton
				expand:	false;
				add:	self widgets addressBar
				expand:	true;
				add:	self widgets openButton
				expand:	false;
				add:	self widgets copyButton
				expand:	false;
				yourself
		)
		expand:	false;
		add:	self widgets mapArea
		expand:	true;
		add:	self widgets progressLabel
		expand:	false;
		add:	self widgets removeLineButton
		expand:	false;
		add:	self widgets addLineButton
		height:	self buttonHeight * 3;
		add:	self widgets warningLabel
		expand:	false;
		yourself.
]

{ #category : 'private' }
ViewPortraitTheodoliteMobileLabRudesheim >> defaultWidgets [
	^ Rudesheim MobileLab Theodolite Widgets
		owner:	self.
]

{ #category : 'accessing' }
ViewPortraitTheodoliteMobileLabRudesheim >> widgets [
	^ widgets
		ifNil:
		[
			widgets := self defaultWidgets.
		].
]
