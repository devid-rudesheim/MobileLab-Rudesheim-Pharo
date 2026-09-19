"
An ApplicationTheodoliteMobileLabRudesheimTest is a test class for testing that
`Rudesheim MobileLab Theodolite Application` resolves to a working SpApplication subclass.
"
Class {
	#name : 'ApplicationTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite Application.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testNewRunSucceeds [
	self
		shouldnt:	[ self basicTarget run ]
		raise:	Error.
]