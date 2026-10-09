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
	#classTraits : 'TExportableMobileLabRudesheim classTrait',
	#category : 'Rudesheim-MobileLab-Theodolite-Namespace',
	#package : 'Rudesheim-MobileLab-Theodolite',
	#tag : 'Namespace'
}

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> Application [
	^ ApplicationTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> BearingLines [
	^ BearingLinesTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> Key [
	^ KeyTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> LaunchRequested [
	^ LaunchRequestedTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> Layer [
	^ LayerTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> Markers [
	^ MarkersTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> Model [
	^ ModelTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> Rays [
	^ RaysTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> Renderer [
	^ RendererTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> SpecBuilder [
	^ SpecBuilderTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> ViewLandscape [
	^ ViewLandscapeTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
TheodoliteMobileLabRudesheim class >> ViewPortrait [
	^ ViewPortraitTheodoliteMobileLabRudesheim.
]

{ #category : 'namespace' }
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
