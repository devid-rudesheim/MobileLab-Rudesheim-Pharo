"
A WindowScreenPolicyMobileLabRudesheim is the ScreenPolicy that opens a View as an ordinary window,
reached as `Rudesheim MobileLab ScreenPolicy Window`. It is the default of every MobileLab
Application, and what the `MobileLab` World Menu items use, so launching an app from the World
Menu never disturbs the World the menu lives in (see WorldScreenPolicyMobileLabRudesheim for the
policy that does).

Every ScreenPolicy understands `open:titled:` -- open the View (an SpPresenter) with the given
title, and answer the window it opened, which the Application registers as its own.
"
Class {
	#name : 'WindowScreenPolicyMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-ScreenPolicy',
	#package : 'Rudesheim-MobileLab',
	#tag : 'ScreenPolicy'
}

{ #category : 'opening' }
WindowScreenPolicyMobileLabRudesheim class >> open: aViewSpPresenter
titled: aTitleString [
	^ aViewSpPresenter open
		title:	aTitleString;
		yourself.
]
