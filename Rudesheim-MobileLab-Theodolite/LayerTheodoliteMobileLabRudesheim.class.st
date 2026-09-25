"
A LayerTheodoliteMobileLabRudesheim is the shared base for the two things Theodolite's map draws
polymorphically -- RaysTheodoliteMobileLabRudesheim and MarkersTheodoliteMobileLabRudesheim
(`{ Rays. Markers } do: [ :each | aCanvas draw: (each renderer: renderer) ]`,
SpecBuilderTheodoliteMobileLabRudesheim>>#bindModel:toView:'s own comment) -- holding what both
identically need: `renderer` (a RendererTheodoliteMobileLabRudesheim, one redraw's shared
`lines`/`bounds`/`extent`/`scale`/#screenPointFor: context) and the class-side #renderer:/
instance-side #renderer/#renderer: that build and access it. Reached as `Rudesheim MobileLab
Theodolite Layer`.

Each subclass defines only its own #drawOnAthensCanvas: -- the one piece that actually differs
between drawing rays and drawing markers -- per this project's 'prefer polymorphism over switch/if
on kind' convention (~/.claude/CLAUDE.md's Design section): the shape both share belongs on one
base, and only the behavior that differs stays on the two leaf classes.
"
Class {
	#name : 'LayerTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'renderer'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'instance creation' }
LayerTheodoliteMobileLabRudesheim class >> renderer: aRendererTheodoliteMobileLabRudesheim [
	^ self new
		renderer:	aRendererTheodoliteMobileLabRudesheim;
		yourself.
]

{ #category : 'accessing' }
LayerTheodoliteMobileLabRudesheim >> renderer [
	^ renderer.
]

{ #category : 'accessing' }
LayerTheodoliteMobileLabRudesheim >> renderer: aRendererTheodoliteMobileLabRudesheim [
	renderer := aRendererTheodoliteMobileLabRudesheim assertNotNilRudesheim.
]
