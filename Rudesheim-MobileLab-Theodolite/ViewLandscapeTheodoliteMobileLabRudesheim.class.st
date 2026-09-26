"
A ViewLandscapeTheodoliteMobileLabRudesheim is Theodolite's landscape-orientation View presenter
(note/ios-triangulation-app.md section 2.2 / NocoDB Sections 項番FD §2.2). Reached as
`Rudesheim MobileLab Theodolite ViewLandscape`.

It only arranges the widgets it gets from its `widgets` (a WidgetsTheodoliteMobileLabRudesheim,
shared with the portrait View so both orientations show the same widget set without duplicating
it) into the landscape structure: a full-width, fixed-height top row (discard/address/open/copy),
a middle row with a variable-width self-drawn map area (`widgets mapArea`, an SpAthensPresenter
rendered by RaysTheodoliteMobileLabRudesheim/MarkersTheodoliteMobileLabRudesheim -- decision
recorded in NocoDB Sections 項番GM)
plus a fixed-width column (add/remove/progress), and a full-width, fixed-height bottom row holding
`widgets warningLabel` alone. add/remove expand to fill the column's remaining vertical space
(larger tap targets); progress stays fixed-height. It does not itself answer
#progressLabel/#addressBar/etc -- callers that need the widget protocol
SpecBuilderTheodoliteMobileLabRudesheim>>#bindModel:toView: needs go through `self widgets`
directly. The portrait layout (項番FD §2.1) is separate, not-yet-built work, but must place
`warningLabel` the same way -- as its own full-width row pinned to the bottom of the window,
below everything else -- per the layout decision recorded in NocoDB Sections 項番GO.
"
Class {
	#name : 'ViewLandscapeTheodoliteMobileLabRudesheim',
	#superclass : 'SpPresenter',
	#instVars : [
		'widgets'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'layout' }
ViewLandscapeTheodoliteMobileLabRudesheim >> defaultLayout [
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
		add:
		(
			SpBoxLayout newLeftToRight
				add:	self widgets mapArea
				expand:	true;
				add:
				(
					SpBoxLayout newTopToBottom
						add:	self widgets addLineButton
						expand:	true;
						add:	self widgets removeLineButton
						expand:	true;
						add:	self widgets progressLabel
						expand:	false;
						yourself
				)
				expand:	false;
				yourself
		)
		expand:	true;
		add:	self widgets warningLabel
		expand:	false;
		yourself.
]

{ #category : 'private' }
ViewLandscapeTheodoliteMobileLabRudesheim >> defaultWidgets [
	^ Rudesheim MobileLab Theodolite Widgets
		owner:	self.
]

{ #category : 'accessing' }
ViewLandscapeTheodoliteMobileLabRudesheim >> widgets [
	^ widgets
		ifNil:
		[
			widgets := self defaultWidgets.
		].
]
