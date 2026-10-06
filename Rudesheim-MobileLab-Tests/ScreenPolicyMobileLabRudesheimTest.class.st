"
A ScreenPolicyMobileLabRudesheimTest is a test class for testing that the
`Rudesheim MobileLab ScreenPolicy` namespace reaches its two policies, Window and World.
"
Class {
	#name : 'ScreenPolicyMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
ScreenPolicyMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab ScreenPolicy.
]

{ #category : 'tests' }
ScreenPolicyMobileLabRudesheimTest >> testReachableFromTheMobileLabNamespace [
	self
		assert:	Rudesheim MobileLab ScreenPolicy
		identicalTo:	self targetClass.
]

{ #category : 'tests' }
ScreenPolicyMobileLabRudesheimTest >> testWindowAnswersWindowScreenPolicy [
	self
		assert:	self targetClass Window name
		equals:	#WindowScreenPolicyMobileLabRudesheim.
]

{ #category : 'tests' }
ScreenPolicyMobileLabRudesheimTest >> testWorldAnswersWorldScreenPolicy [
	self
		assert:	self targetClass World name
		equals:	#WorldScreenPolicyMobileLabRudesheim.
]
