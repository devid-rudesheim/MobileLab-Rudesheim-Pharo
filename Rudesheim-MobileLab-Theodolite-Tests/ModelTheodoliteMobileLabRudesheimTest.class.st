"
A ModelTheodoliteMobileLabRudesheimTest tests the BearingLine/warning coordination described in
note/ios-triangulation-app.md section 7.3 (NocoDB Sections 項番FM): recording up to maxSize (3)
lines, rejecting a 4th in favor of a launch-request announcement, rejecting non-intersecting
(near-parallel) lines with a warning, and clearing that warning on removal.
"
Class {
	#name : 'ModelTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
ModelTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite Model.
]

{ #category : 'private' }
ModelTheodoliteMobileLabRudesheimTest >> bearingFrom: anOrigin
toward: aTarget [
	|
		dx
		dy
		radians
		degrees
	|

	dx := aTarget x - anOrigin x.
	dy := aTarget y - anOrigin y.

	radians :=
		dx
			arcTan:	dy.

	degrees := radians * 180 / Float pi.

	^ degrees < 0
		ifTrue:
		[
			degrees + 360.
		]
		ifFalse:
		[
			degrees.
		].
]

{ #category : 'tests' }
ModelTheodoliteMobileLabRudesheimTest >> testDiscardAllClearsEverything [
	|
		model
	|

	model := self basicTarget.

	model
		addLineAt:	0 , 0
		heading:	90.

	model discardAll.

	self
		assert:	model bearingLines size
		equals:	0.

	self
		assert:	model warning value isEmpty.
]

{ #category : 'tests' }
ModelTheodoliteMobileLabRudesheimTest >> testFourthAttemptTriggersLaunchWithoutBeingRecorded [
	|
		model
		target
		origins
		launchCount
	|

	model := self basicTarget.
	target := 100 , 50.

	origins :=
	{
		( 0 , 0 ).
		( 200 , 0 ).
		( 0 , 200 )
	}.

	origins
		do:
		[ :origin |
			model
				addLineAt:	origin
				heading:
				(
					self
						bearingFrom:	origin
						toward:	target
				).
		].

	launchCount := 0.

	model bearingLines announcer
		when:	Rudesheim MobileLab Theodolite LaunchRequested
		do:
		[
			launchCount := launchCount + 1.
		]
		for:	self.

	model
		addLineAt:	50 , 50
		heading:
		(
			self
				bearingFrom:	50 , 50
				toward:	target
		).

	self
		assert:	model bearingLines size
		equals:	3.

	self
		assert:	launchCount
		equals:	1.

	self
		assert:	model bearingLines intersectionPoint size
		equals:	1.

	self
		assert:	model bearingLines mapURL size
		equals:	1.
]

{ #category : 'tests' }
ModelTheodoliteMobileLabRudesheimTest >> testNonIntersectingLineIsRejectedWithWarning [
	|
		model
	|

	model := self basicTarget.

	model
		addLineAt:	0 , 0
		heading:	90.

	model
		addLineAt:	0 , 5
		heading:	90.

	self
		assert:	model bearingLines size
		equals:	1.

	self
		assert:	model warning value size
		equals:	1.
]

{ #category : 'tests' }
ModelTheodoliteMobileLabRudesheimTest >> testRemoveLastClearsWarning [
	|
		model
	|

	model := self basicTarget.

	model
		addLineAt:	0 , 0
		heading:	90.

	model
		addLineAt:	0 , 5
		heading:	90.

	model bearingLines removeLast.

	self
		assert:	model warning value isEmpty.
]
