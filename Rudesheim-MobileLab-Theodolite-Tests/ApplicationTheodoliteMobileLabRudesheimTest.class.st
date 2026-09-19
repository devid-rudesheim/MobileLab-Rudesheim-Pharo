"
An ApplicationTheodoliteMobileLabRudesheimTest is a test class for testing that
`Rudesheim MobileLab Theodolite Application` resolves to a working SpApplication subclass.
"
Class {
	#name : 'ApplicationTheodoliteMobileLabRudesheimTest',
	#superclass : 'TestCase',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testApplicationResolvesFromRudesheimMobileLabTheodolite [
	self
		assert:	self class targetClass MobileLab Theodolite Application
		equals:	ApplicationTheodoliteMobileLabRudesheim.
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testApplicationIsSpApplication [
	self
		assert:	(ApplicationTheodoliteMobileLabRudesheim inheritsFrom: SpApplication).
]

{ #category : 'tests' }
ApplicationTheodoliteMobileLabRudesheimTest >> testNewRunSucceeds [
	self
		shouldnt:	[ ApplicationTheodoliteMobileLabRudesheim new run ]
		raise:	Error.
]