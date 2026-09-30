"
A ViewPortraitTheodoliteMobileLabRudesheim is Theodolite's portrait-orientation View presenter
(note/ios-triangulation-app.md section 2.1 / NocoDB Sections 項番FD §2.1). Reached as
`Rudesheim MobileLab Theodolite ViewPortrait`.

Like ViewLandscapeTheodoliteMobileLabRudesheim, it only arranges the widgets it gets from its
`widgets` (a WidgetsTheodoliteMobileLabRudesheim, the widget set shared by both orientations) into
the portrait structure, top to bottom: the variable-height self-drawn map area (`widgets mapArea`,
項番GM), a fixed-height main operation row (add/remove/progress), a fixed-height rarely-used row
(discard/address/open/copy), and `widgets warningLabel` alone as a full-width, fixed-height row
pinned to the bottom of the window, below everything else -- per the layout decision recorded in
NocoDB Sections 項番GO (which supersedes 項番FD §2.1's original placement of the warning area
between the map and the main row). add/remove expand to share the main row's width equally
(larger tap targets); progress stays fixed-width. It does not itself answer
#progressLabel/#addressBar/etc -- callers that need the widget protocol
SpecBuilderTheodoliteMobileLabRudesheim>>#bindModel:toView: needs go through `self widgets`
directly.
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

{ #category : 'layout' }
ViewPortraitTheodoliteMobileLabRudesheim >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add:	self widgets mapArea
		expand:	true;
		add:
		(
			SpBoxLayout newLeftToRight
				add:	self widgets addLineButton
				expand:	true;
				add:	self widgets removeLineButton
				expand:	true;
				add:	self widgets progressLabel
				expand:	false;
				yourself
		)
		expand:	false;
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
