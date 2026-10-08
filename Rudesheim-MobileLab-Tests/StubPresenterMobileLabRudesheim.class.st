"
A StubPresenterMobileLabRudesheim is a stand-in for the SpPresenter (the View) a ScreenPolicy
opens, and also for the window objects that View's #open / #asWorldWindow answer: #open answers
the stub itself, #asWorldWindow answers a second stub (#worldWindow). Every message a ScreenPolicy
is expected to send it is recorded, in order, in #events, so a test can assert on what the policy
did without opening a real window or taking over the real World -- #asWorldWindow is irreversible
on a real SpPresenter (SpWorldPresenter class>>#setUpWorld deletes every morph of the World, see
NocoDB Sections 項番H7), which is exactly why a ScreenPolicy's test must never send it to one.

#currentWorld answers a small Morph standing in for the World (it has a Morph of its own, 50@40
-- the size a real World's container Morph has right after #asWorldWindow's #open, so a test can
see it grow to the World's bounds). #defer: evaluates its block immediately, since there is no
UI process to defer to.
"
Class {
	#name : 'StubPresenterMobileLabRudesheim',
	#superclass : 'Object',
	#instVars : [
		'events',
		'worldWindow',
		'currentWorld'
	],
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'stubbing' }
StubPresenterMobileLabRudesheim >> asWorldWindow [
	self events
		add:	#asWorldWindow.

	^ self worldWindow.
]

{ #category : 'accessing' }
StubPresenterMobileLabRudesheim >> currentWorld [
	^ currentWorld
		ifNil:
		[
			currentWorld := self defaultCurrentWorld.
		].
]

{ #category : 'private' }
StubPresenterMobileLabRudesheim >> defaultCurrentWorld [
	^ Morph new
		bounds:
		(
			0 @ 0
				corner:	300 @ 200
		);
		addMorph:
		(
			Morph new
				bounds:
				(
					0 @ 0
						corner:	50 @ 40
				);
				yourself
		);
		yourself.
]

{ #category : 'private' }
StubPresenterMobileLabRudesheim >> defaultEvents [
	^ OrderedCollection new.
]

{ #category : 'private' }
StubPresenterMobileLabRudesheim >> defaultWorldWindow [
	^ self class new.
]

{ #category : 'stubbing' }
StubPresenterMobileLabRudesheim >> defer: aBlock [
	self events
		add:	#defer:.

	aBlock value.
]

{ #category : 'accessing' }
StubPresenterMobileLabRudesheim >> events [
	^ events
		ifNil:
		[
			events := self defaultEvents.
		].
]

{ #category : 'stubbing' }
StubPresenterMobileLabRudesheim >> open [
	self events
		add:	#open.
]

{ #category : 'stubbing' }
StubPresenterMobileLabRudesheim >> title: aString [
	self events
		add:	#title: -> aString.
]

{ #category : 'accessing' }
StubPresenterMobileLabRudesheim >> worldWindow [
	^ worldWindow
		ifNil:
		[
			worldWindow := self defaultWorldWindow.
		].
]
