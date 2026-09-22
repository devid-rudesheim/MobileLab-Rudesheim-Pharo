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
	"Returns a normalized bearing (Rudesheim-MobileLab's (-0.5, 0.5] form, see GRay class >>
	origin:normalizedBearing:'s comment), not raw degrees. delta x arcTan: delta y already matches
	atan2's own (-180, 180] convention, so dividing straight by 360 lands exactly on the target
	form -- no separate wrap-into-negative step is needed (unlike
	Number>>#asNormalizedBearingRudesheim, which has to wrap because it starts from [0, 360)
	instead)."
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
	^ degrees / 360.
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
				normalizedBearing:	0.25
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
						normalizedBearing:
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
				normalizedBearing:
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
				normalizedBearing:	0.25
		).

	model bearingLines
		add:
		(
			GRay
				origin:	0 , 5
				normalizedBearing:	0.25
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
				normalizedBearing:	0.25
		).

	model bearingLines
		add:
		(
			GRay
				origin:	0 , 5
				normalizedBearing:	0.25
		).

	model bearingLines removeLast.

	self
		assert:	model warning value isEmpty.
]
