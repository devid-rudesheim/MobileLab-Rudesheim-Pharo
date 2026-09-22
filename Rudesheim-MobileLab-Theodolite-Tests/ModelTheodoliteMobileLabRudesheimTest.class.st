"
A ModelTheodoliteMobileLabRudesheimTest tests the bearing-line/warning coordination described in
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
		delta
		radians
		degrees
	|

	delta := aTarget - anOrigin.

	radians :=
		delta x
			arcTan:	delta y.

	degrees := radians * 180 / Float pi.

	0 > degrees
		ifTrue:
		[
			^ degrees + 360.
		].

	^ degrees.
]

{ #category : 'tests' }
ModelTheodoliteMobileLabRudesheimTest >> testDiscardAllClearsEverything [
	|
		model
	|

	model := self basicTarget.

	model bearingLines
		add:
		(
			GRay
				origin:	0 , 0
				bearing:	90
		).

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
			model bearingLines
				add:
				(
					GRay
						origin:	origin
						bearing:
						(
							self
								bearingFrom:	origin
								toward:	target
						)
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

	model bearingLines
		add:
		(
			GRay
				origin:	50 , 50
				bearing:
				(
					self
						bearingFrom:	50 , 50
						toward:	target
				)
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

	model bearingLines
		add:
		(
			GRay
				origin:	0 , 0
				bearing:	90
		).

	model bearingLines
		add:
		(
			GRay
				origin:	0 , 5
				bearing:	90
		).

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

	model bearingLines
		add:
		(
			GRay
				origin:	0 , 0
				bearing:	90
		).

	model bearingLines
		add:
		(
			GRay
				origin:	0 , 5
				bearing:	90
		).

	model bearingLines removeLast.

	self
		assert:	model warning value isEmpty.
]
