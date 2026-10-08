"
A WorldScreenPolicyMobileLabRudesheim is the ScreenPolicy that opens a View as the Pharo World
itself, reached as `Rudesheim MobileLab ScreenPolicy World`: the View's `asWorldWindow` (the same
mechanism Pharo Launcher's openAsWorld uses, see NocoDB Sections 項番H7), so there is no window
frame, and Pharo's own menubar, taskbar and other windows are gone.

IRREVERSIBLE: `asWorldWindow` makes SpWorldPresenter class>>#setUpWorld delete every morph of the
World and hide the taskbar, with no way back short of restarting the image. So never choose this
policy from somewhere a development image's World must survive (the `MobileLab` World Menu items
use WindowScreenPolicyMobileLabRudesheim, not this), and never save an image after trying it.

Right after #open, the World's only morph is a bare 50@40 Morph holding the View, and nothing
grows it, so the View would huddle in the top-left corner; this policy therefore sets every morph
of the World to the World's bounds, on the UI process (`defer:`), which is where Morphic must be
touched. Following a change of the World's size later (a device rotation) is not handled yet.

Also not handled here: the Welcome window that opens after startup and covers the World (the
startup script that chooses this policy closes it).
"
Class {
	#name : 'WorldScreenPolicyMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-ScreenPolicy',
	#package : 'Rudesheim-MobileLab',
	#tag : 'ScreenPolicy'
}

{ #category : 'opening' }
WorldScreenPolicyMobileLabRudesheim class >> open: aViewSpPresenter
titled: aTitleString [
	|
		worldWindow
	|

	worldWindow := aViewSpPresenter asWorldWindow.

	worldWindow
		title:	aTitleString.

	worldWindow open.

	worldWindow
		defer:
		[
			worldWindow currentWorld submorphs
				do:
				[ :aMorph |
					aMorph
						bounds:	worldWindow currentWorld bounds.
				].
		].

	^ worldWindow.
]
