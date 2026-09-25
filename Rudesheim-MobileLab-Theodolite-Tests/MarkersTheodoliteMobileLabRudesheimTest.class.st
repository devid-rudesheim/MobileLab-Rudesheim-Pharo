"
A MarkersTheodoliteMobileLabRudesheimTest covers only what is testable headlessly: the #renderer/
#renderer: accessor contract. #draw itself needs a real Athens canvas, out of scope for a headless
SUnit run (same rationale as MapDrawingTheodoliteMobileLabRudesheimTest's own comment).
"
Class {
	#name : 'MarkersTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
MarkersTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite Markers.
]

{ #category : 'tests' }
MarkersTheodoliteMobileLabRudesheimTest >> testRendererClassSideCreationSetsRenderer [
	|
		renderer
		markers
	|

	renderer := Rudesheim MobileLab Theodolite MapDrawing new.

	markers :=
		self targetClass
			renderer:	renderer.

	self
		assert:	markers renderer
		equals:	renderer.
]
