"
A RaysTheodoliteMobileLabRudesheimTest covers only what is testable headlessly: the #renderer/
#renderer: accessor contract. #draw itself needs a real Athens canvas, out of scope for a headless
SUnit run (same rationale as MapDrawingTheodoliteMobileLabRudesheimTest's own comment).
"
Class {
	#name : 'RaysTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
RaysTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite Rays.
]

{ #category : 'tests' }
RaysTheodoliteMobileLabRudesheimTest >> testRendererClassSideCreationSetsRenderer [
	|
		renderer
		rays
	|

	renderer := Rudesheim MobileLab Theodolite MapDrawing new.

	rays :=
		self targetClass
			renderer:	renderer.

	self
		assert:	rays renderer
		equals:	renderer.
]
