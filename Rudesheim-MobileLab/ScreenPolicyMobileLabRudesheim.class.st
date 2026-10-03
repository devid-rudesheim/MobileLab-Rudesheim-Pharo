"
A ScreenPolicyMobileLabRudesheim is the namespace for the ScreenPolicy classes, reached as
`Rudesheim MobileLab ScreenPolicy`. A ScreenPolicy decides how much of the screen a MobileLab
Application's View takes: `Window` opens it as an ordinary window (the default), `World` opens it as
the Pharo World itself, hiding Pharo's own menubar/taskbar/windows, for an app that should look like
a native one (e.g. on iOS). An Application is given its policy with `screenPolicy:`:

mobileLib := Rudesheim MobileLab.
mobileLib Theodolite Application new
	screenPolicy:	mobileLib ScreenPolicy World;
	run.

Both policies are stateless, so the classes themselves are the policy objects.
"
Class {
	#name : 'ScreenPolicyMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Namespace',
	#package : 'Rudesheim-MobileLab',
	#tag : 'Namespace'
}

{ #category : 'accessing' }
ScreenPolicyMobileLabRudesheim class >> Window [
	^ WindowScreenPolicyMobileLabRudesheim.
]

{ #category : 'accessing' }
ScreenPolicyMobileLabRudesheim class >> World [
	^ WorldScreenPolicyMobileLabRudesheim.
]
