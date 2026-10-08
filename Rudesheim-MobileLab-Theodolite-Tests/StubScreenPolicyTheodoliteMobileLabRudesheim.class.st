"
A StubScreenPolicyTheodoliteMobileLabRudesheim is a stand-in for a MobileLab ScreenPolicy
(`Rudesheim MobileLab ScreenPolicy Window` / `World`) that, instead of opening the View it is
given, only records it and the title (#views / #titles, in the order they arrived) and answers
itself as the 'window' it opened -- so a test can ask an Application what it hands to its
screenPolicy, and which window it registers, without opening a window (or, for World, wrecking the
World). It is an instance rather than a class because it has to remember what it was given;
the Application only sends `open:titled:`, so either works there.
"
Class {
	#name : 'StubScreenPolicyTheodoliteMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'views',
		'titles'
	],
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'private' }
StubScreenPolicyTheodoliteMobileLabRudesheim >> defaultTitles [
	^ OrderedCollection new.
]

{ #category : 'private' }
StubScreenPolicyTheodoliteMobileLabRudesheim >> defaultViews [
	^ OrderedCollection new.
]

{ #category : 'stubbing' }
StubScreenPolicyTheodoliteMobileLabRudesheim >> open: aViewSpPresenter
titled: aTitleString [
	self views
		add:	aViewSpPresenter.

	self titles
		add:	aTitleString.

	^ self.
]

{ #category : 'accessing' }
StubScreenPolicyTheodoliteMobileLabRudesheim >> titles [
	^ titles
		ifNil:
		[
			titles := self defaultTitles.
		].
]

{ #category : 'accessing' }
StubScreenPolicyTheodoliteMobileLabRudesheim >> views [
	^ views
		ifNil:
		[
			views := self defaultViews.
		].
]
