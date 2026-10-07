"
A TheodoliteMobileLabRudesheim is the namespace of the Theodolite app (`Rudesheim MobileLab
Theodolite`); its class-side accessors reach the app's classes. It is also what the app hands to
`Rudesheim MobileLab Export` classes when its exported iOS project is prepared: they ask it for the
`Application` class (to start it) and for its `permissions` (the Rudesheim MobileLab Permission
objects, with the sentence shown to the user, that go into the Info.plist).
"
Class {
	#name : 'TheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Theodolite-Namespace',
	#package : 'Rudesheim-MobileLab-Theodolite',
	#tag : 'Namespace'
}

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> Application [
	^ ApplicationTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> BearingLines [
	^ BearingLinesTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> Key [
	^ KeyTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> LaunchRequested [
	^ LaunchRequestedTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> Layer [
	^ LayerTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> Markers [
	^ MarkersTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> Model [
	^ ModelTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> Rays [
	^ RaysTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> Renderer [
	^ RendererTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> SpecBuilder [
	^ SpecBuilderTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> ViewLandscape [
	^ ViewLandscapeTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> ViewPortrait [
	^ ViewPortraitTheodoliteMobileLabRudesheim.
]

{ #category : 'accessing' }
TheodoliteMobileLabRudesheim class >> Widgets [
	^ WidgetsTheodoliteMobileLabRudesheim.
]

{ #category : 'exporting' }
TheodoliteMobileLabRudesheim class >> permissions [
	^
	{
		Rudesheim MobileLab Permission LocationService
			description:	'Theodolite uses your current location and heading to record each bearing line.'
	}.
]
