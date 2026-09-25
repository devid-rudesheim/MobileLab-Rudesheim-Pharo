"
A BearingLinesTheodoliteMobileLabRudesheimTest exhaustively exercises
BearingLinesTheodoliteMobileLabRudesheim's public interface directly -- constructing it bare via
`self basicTarget` (`self targetClass new`), the same way any caller other than
ModelTheodoliteMobileLabRudesheim>>#defaultBearingLines would, rather than only ever going through
the Model the way ModelTheodoliteMobileLabRudesheimTest does. That distinction caught two
implementation bugs neither ModelTheodoliteMobileLabRudesheimTest nor
SpecBuilderTheodoliteMobileLabRudesheimTest had surfaced, because both of those only ever exercise
a BearingLines instance the Model already wired up with #warning: -- entirely unrelated to the
app's own OS-dispatch surface (#push/#pop's `Smalltalk os rudesheim location currentRay`, out of
scope here, see BearingLinesTheodoliteMobileLabRudesheim's own comment):
- #removeLast (and #pop) used to raise a `CollectionIsEmpty` error when the collection was already
  empty -- #removeLineButton's action calls it unconditionally with no count guard, so this was
  reachable directly from the UI. Fixed to no-op instead (#testRemoveLastOnEmptyIsNoOpNotError /
  #testPopOnEmptyIsNoOpNotError below).
- #warning used to answer whatever the `warning` instance variable held, which is nil until
  #warning: is sent -- but every #add: branch (including the success path) sends `self warning
  value:`, so a bare `new` instance crashed with `nil doesNotUnderstand: #value:` on its very
  first #add:. Fixed to default lazily to a fresh NewValueHolder, matching this project's
  Smalltalk-specific default-to-lazy-initialization rule (#testFirstAddIsAcceptedOnABareInstance /
  #testWarningDefaultsToEmptyOnABareInstance below).
"
Class {
	#name : 'BearingLinesTheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
BearingLinesTheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite BearingLines.
]

{ #category : 'private' }
BearingLinesTheodoliteMobileLabRudesheimTest >> assertMapURL: aZnUrl
matchesPoint: aGPoint [
	"Duplicated from ModelTheodoliteMobileLabRudesheimTest -- see that method's comment for why the
	'll' query value is parsed back out and compared numerically instead of via displayString."
	|
		stream
		llY
		llX
	|

	stream :=
	(
		aZnUrl
			queryAt:	'll'
	) readStream.

	llY :=
	(
		stream
			upTo:	$,
	) asNumber.

	llX := stream upToEnd asNumber.

	self
		assert:	llX
		closeTo:	aGPoint x.

	self
		assert:	llY
		closeTo:	aGPoint y.
]

{ #category : 'private' }
BearingLinesTheodoliteMobileLabRudesheimTest >> bearingFrom: anOrigin
toward: aTarget [
	"Duplicated from ModelTheodoliteMobileLabRudesheimTest -- see that method's comment for why
	dividing the atan2-form radians straight by 360 already lands on Rudesheim-MobileLab's
	normalized bearing form without a separate wrap step."
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
BearingLinesTheodoliteMobileLabRudesheimTest >> testAddAtCapacityAnnouncesLaunchRequestedInsteadOfRecording [
	|
		lines
		target
		origins
		launchCount
	|

	lines := self basicTarget.
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
			lines
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

	lines announcer
		when:	Rudesheim MobileLab Theodolite LaunchRequested
		do:
		[
			launchCount := launchCount + 1.
		]
		for:	self.

	lines
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
		assert:	lines size
		equals:	3.

	self
		assert:	launchCount
		equals:	1.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testAddAtCapacityIgnoresIntersectionAndLeavesWarningUntouched [
	"The capacity guard is the first thing #add: checks -- a 4th line that would otherwise
	intersect fine (and so would never itself set a warning) must still trigger
	LaunchRequestedTheodoliteMobileLabRudesheim instead of being evaluated for intersection, and
	must leave whatever warning value was already there (here: cleared by the 3rd, accepted add)
	exactly as it was."
	|
		lines
		target
		origins
	|

	lines := self basicTarget.
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
			lines
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

	self
		assert:	lines warning value isEmpty.

	lines
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
		assert:	lines size
		equals:	3.

	self
		assert:	lines warning value isEmpty.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testAddRejectsNonIntersectingLineAndSetsWarning [
	|
		lines
	|

	lines := self basicTarget.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	lines
		add:
		(
			GRay
				origin:	0 , 5
				normalizedBearing:	0.25
		).

	self
		assert:	lines size
		equals:	1.

	self
		assert:	lines warning value size
		equals:	1.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testAddReturnsTheArgumentRegardlessOfOutcome [
	"#add:'s three branches (accepted / rejected-non-intersecting / rejected-at-capacity) all
	answer the GRay argument -- callers should be able to rely on `lines add: aGRay` always
	answering `aGRay` itself, the same contract OrderedCollection>>#add: has."
	|
		lines
		accepted
		rejected
		atCapacity
	|

	lines := self basicTarget.

	accepted :=
		GRay
			origin:	0 , 0
			normalizedBearing:	0.25.

	self
		assert:
		(
			lines
				add:	accepted
		) == accepted.

	rejected :=
		GRay
			origin:	0 , 5
			normalizedBearing:	0.25.

	self
		assert:
		(
			lines
				add:	rejected
		) == rejected.

	lines
		add:
		(
			GRay
				origin:	5 , -5
				normalizedBearing:	0.0
		).

	atCapacity :=
		GRay
			origin:	1 , 1
			normalizedBearing:	0.1.

	self
		assert:
		(
			lines
				add:	atCapacity
		) == atCapacity.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testFirstAddIsAcceptedOnABareInstance [
	"With nothing recorded yet, #allSatisfy: over an empty collection is vacuously true, so the
	very first line is always accepted regardless of its bearing -- and, on a bare `new` instance
	(never sent #warning:), this used to crash: every #add: branch touches #warning, including this
	success path, and #warning used to just answer the unset `warning` instance variable (nil)."
	|
		lines
	|

	lines := self basicTarget.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	self
		assert:	lines size
		equals:	1.

	self
		assert:	lines warning value isEmpty.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testIntersectionPointEmptyWithFewerThanTwoLines [
	|
		lines
	|

	lines := self basicTarget.

	self
		assert:	lines intersectionPoint isEmpty.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	self
		assert:	lines intersectionPoint isEmpty.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testIntersectionPointWithTwoIntersectingLines [
	|
		lines
	|

	lines := self basicTarget.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	lines
		add:
		(
			GRay
				origin:	10 , 10
				normalizedBearing:	0.5
		).

	self
		assert:	lines intersectionPoint size
		equals:	1.

	self
		assert:	lines intersectionPoint first x
		closeTo:	10.

	self
		assert:	lines intersectionPoint first y
		closeTo:	0.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testMapURLEmptyWithFewerThanTwoLines [
	|
		lines
	|

	lines := self basicTarget.

	self
		assert:	lines mapURL isEmpty.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	self
		assert:	lines mapURL isEmpty.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testMapURLWithIntersectingLines [
	|
		lines
	|

	lines := self basicTarget.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	lines
		add:
		(
			GRay
				origin:	10 , 10
				normalizedBearing:	0.5
		).

	self
		assert:	lines mapURL size
		equals:	1.

	self
		assertMapURL:	lines mapURL first
		matchesPoint:	10 , 0.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testMaxSizeIsThree [
	self
		assert:	self targetClass maxSize
		equals:	3.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testNewInstanceIsEmpty [
	self
		assert:	self basicTarget size
		equals:	0.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testPopIsAliasForRemoveLast [
	|
		lines
		first
		second
		result
	|

	lines := self basicTarget.

	first :=
		GRay
			origin:	0 , 0
			normalizedBearing:	0.25.
	second :=
		GRay
			origin:	5 , -5
			normalizedBearing:	0.0.

	lines
		add:	first;
		add:	second.

	result := lines pop.

	self
		assert:	result == second.

	self
		assert:	lines size
		equals:	1.

	self
		assert:	lines warning value isEmpty.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testPopOnEmptyIsNoOpNotError [
	|
		lines
	|

	lines := self basicTarget.

	self
		shouldnt:
		[
			lines pop.
		]
		raise:	Error.

	self
		assert:	lines size
		equals:	0.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testRemoveLastClearsWarning [
	|
		lines
	|

	lines := self basicTarget.

	lines
		add:
		(
			GRay
				origin:	0 , 0
				normalizedBearing:	0.25
		).

	lines
		add:
		(
			GRay
				origin:	0 , 5
				normalizedBearing:	0.25
		).

	self
		assert:	lines warning value size
		equals:	1.

	lines removeLast.

	self
		assert:	lines warning value isEmpty.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testRemoveLastOnEmptyIsNoOpNotError [
	"#removeLineButton's action calls #pop (an alias for this) unconditionally, with no size guard
	-- pressing 'Remove line' with nothing recorded must not crash. This used to raise
	`CollectionIsEmpty: an OrderedCollection() is empty`."
	|
		lines
	|

	lines := self basicTarget.

	self
		shouldnt:
		[
			lines removeLast.
		]
		raise:	Error.

	self
		assert:	lines size
		equals:	0.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testRemoveLastRemovesTheLastAddedLine [
	|
		lines
		first
		second
		result
	|

	lines := self basicTarget.

	first :=
		GRay
			origin:	0 , 0
			normalizedBearing:	0.25.
	second :=
		GRay
			origin:	5 , -5
			normalizedBearing:	0.0.

	lines
		add:	first;
		add:	second.

	result := lines removeLast.

	self
		assert:	result == second.

	self
		assert:	lines size
		equals:	1.

	self
		assert:
		(
			lines
				at:	1
		) == first.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testWarningAccessorRoundTrip [
	|
		lines
		holder
	|

	lines := self basicTarget.
	holder :=
		NewValueHolder
			value:	#(  ).

	lines
		warning:	holder.

	self
		assert:	lines warning == holder.
]

{ #category : 'tests' }
BearingLinesTheodoliteMobileLabRudesheimTest >> testWarningDefaultsToEmptyOnABareInstance [
	self
		assert:	self basicTarget warning value isEmpty.
]
