"
A StubAthensCanvasTheodoliteMobileLabRudesheim is a minimal test-only stand-in for an AthensCanvas,
exposing just enough (#surface answering itself, #extent answering a fixed Point) for
RendererTheodoliteMobileLabRudesheim class>>#renderersFor:canvas: to compute a renderer's #extent
headlessly, without a real Athens surface. Test-only; never opened as a window.
"
Class {
	#name : 'StubAthensCanvasTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
StubAthensCanvasTheodoliteMobileLabRudesheim >> extent [
	^ 200 @ 200.
]

{ #category : 'accessing' }
StubAthensCanvasTheodoliteMobileLabRudesheim >> surface [
	^ self.
]
