"
A WidgetsTheodoliteMobileLabRudesheimTest is a test class for testing that
`Rudesheim MobileLab Theodolite Widgets` builds the five control buttons with Pharo
`Smalltalk ui icons` icons and tooltips instead of text labels.
"
Class {
	#name : 'WidgetsTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
WidgetsTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite Widgets.
]

{ #category : 'private' }
WidgetsTheodoliteMobileLabRudesheimTest >> defaultBasicTarget [
	^ self targetClass
		owner:	SpPresenter new.
]

{ #category : 'tests' }
WidgetsTheodoliteMobileLabRudesheimTest >> testAddLineButtonShowsEditIcon [
	self
		assert:	self basicTarget addLineButton icon
		equals:	(Smalltalk ui icons iconNamed: #glamorousEdit).
]

{ #category : 'tests' }
WidgetsTheodoliteMobileLabRudesheimTest >> testButtonsKeepTheirNamesAsTooltips [
	self
		assert:	self basicTarget addLineButton help
		equals:	'Add line'.
	self
		assert:	self basicTarget removeLineButton help
		equals:	'Remove line'.
	self
		assert:	self basicTarget discardButton help
		equals:	'Discard all'.
	self
		assert:	self basicTarget copyButton help
		equals:	'Copy'.
	self
		assert:	self basicTarget openButton help
		equals:	'Open'.
]

{ #category : 'tests' }
WidgetsTheodoliteMobileLabRudesheimTest >> testButtonsShowNoTextLabel [
	{
		self basicTarget addLineButton.
		self basicTarget removeLineButton.
		self basicTarget discardButton.
		self basicTarget copyButton.
		self basicTarget openButton.
	}
		do:
		[ :each |
			self
				assert:	each label isEmpty.
		].
]

{ #category : 'tests' }
WidgetsTheodoliteMobileLabRudesheimTest >> testCopyButtonShowsCopyIcon [
	self
		assert:	self basicTarget copyButton icon
		equals:	(Smalltalk ui icons iconNamed: #smallCopy).
]

{ #category : 'tests' }
WidgetsTheodoliteMobileLabRudesheimTest >> testDiscardButtonShowsTrashIcon [
	self
		assert:	self basicTarget discardButton icon
		equals:	(Smalltalk ui icons iconNamed: #trash).
]

{ #category : 'tests' }
WidgetsTheodoliteMobileLabRudesheimTest >> testOpenButtonShowsOpenFromUrlIcon [
	self
		assert:	self basicTarget openButton icon
		equals:	(Smalltalk ui icons iconNamed: #glamorousOpenFromUrl).
]

{ #category : 'tests' }
WidgetsTheodoliteMobileLabRudesheimTest >> testRemoveLineButtonShowsUndoIcon [
	self
		assert:	self basicTarget removeLineButton icon
		equals:	(Smalltalk ui icons iconNamed: #undo).
]
