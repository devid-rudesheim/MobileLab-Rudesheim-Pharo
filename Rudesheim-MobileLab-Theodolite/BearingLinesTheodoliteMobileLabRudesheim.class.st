"
A BearingLinesTheodoliteMobileLabRudesheim holds the recorded bearing lines, each a plain GRay
(see the GRay class-side extension #origin:bearing: in this package), up to #maxSize, 3. It
overrides the standard Collection protocol #add:/#removeLast, per note/ios-triangulation-app.md
section 7.3 (NocoDB Sections 項番FM):

- #add: past capacity never records a 4th line; it announces
  LaunchRequestedTheodoliteMobileLabRudesheim instead.
- #add: below capacity checks the new line actually intersects every already-recorded line
  (rejecting near-parallel lines) and keeps the shared warning holder (set by the owning Model,
  see #warning:) in sync either way -- this is the one piece of coordination the design calls out
  as living inside #add: itself, not through separate Model-level observation.
- #intersectionPoint / #mapURL are 0-or-1-element-array query methods (never nil, per the
  project's no-nil convention) computed on demand from the current lines, not cached.

#push:heading:/#pop are the view-facing stack-style entry points action blocks actually call:
#push:heading: builds the GRay from a raw origin point + compass bearing and passes it through
#add: (so the capacity/intersection coordination above still applies); #pop is a plain alias for
#removeLast. Callers that already have a GRay in hand can still use #add:/#removeLast directly.
"
Class {
	#name : 'BearingLinesTheodoliteMobileLabRudesheim',
	#superclass : 'CollectionValueHolder',
	#instVars : [
		'warning'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'accessing' }
BearingLinesTheodoliteMobileLabRudesheim class >> maxSize [
	^ 3.
]

{ #category : 'adding' }
BearingLinesTheodoliteMobileLabRudesheim >> add: aGRay [
	self size >= self class maxSize
		ifTrue:
		[
			self announcer
				announce:	Rudesheim MobileLab Theodolite LaunchRequested new.

			^ aGRay.
		].

	(
		self
			allSatisfy:
			[ :existing |
				(
					existing
						intersectionsWith:	aGRay
				) isNotEmpty.
			]
	)
		ifFalse:
		[
			self warning
				value:
				{
					'This line does not cross the existing lines (nearly parallel); it was not added'
				}.

			^ aGRay.
		].

	self warning
		value:	#(  ).

	^ super
		add:	aGRay.
]

{ #category : 'initialization' }
BearingLinesTheodoliteMobileLabRudesheim >> initialize [
	super initialize.

	self
		value:	OrderedCollection new.
]

{ #category : 'geometry' }
BearingLinesTheodoliteMobileLabRudesheim >> intersectionPoint [
	"0-or-1 array: the average of every pairwise ray intersection currently held (a practical
	stand-in for a full least-squares fit -- Geometry has no built-in N-ray fit, see 項番FG).
	Empty if fewer than 2 lines are recorded, or no pair actually intersects."
	|
		lines
		points
		average
	|

	lines := self asArray.
	points := OrderedCollection new.

	1
		to:	lines size
		do:
		[ :i |
			i + 1
				to:	lines size
				do:
				[ :j |
					(
						(
							lines
								at:	i
						)
							intersectionsWith:
							(
								lines
									at:	j
							)
					)
						do:
						[ :point |
							points
								add:	point.
						].
				].
		].

	points isEmpty
		ifTrue:
		[
			^ #(  ).
		].

	average :=
	(
		points
			inject:	0 , 0
			into:
			[ :sum :each |
				sum + each.
			]
	) asPoint / points size.

	^
	{
		( average x , average y )
	}.
]

{ #category : 'geometry' }
BearingLinesTheodoliteMobileLabRudesheim >> mapURL [
	"0-or-1 array: an Apple Maps ZnUrl for #intersectionPoint. There is no 'maps://' scheme --
	Apple Maps links are plain http(s) URLs to maps.apple.com that the OS intercepts and opens in
	Maps instead of a browser (see
	https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html).
	ZnUrl has no #launch of its own yet -- actually opening it is left to the View/action-block
	layer (out of scope this round, see note/ios-triangulation-app.md 項番FJ item 4)."
	^ self intersectionPoint
		collect:
		[ :point |
			'http://maps.apple.com' asZnUrl
				queryAt:	'll'
				put:	point y printString , ',' , point x printString;
				yourself.
		].
]

{ #category : 'removing' }
BearingLinesTheodoliteMobileLabRudesheim >> pop [
	^ self removeLast.
]

{ #category : 'adding' }
BearingLinesTheodoliteMobileLabRudesheim >> push: aGPoint
heading: aNumber [
	^ self
		add:
		(
			GRay
				origin:	aGPoint
				bearing:	aNumber
		).
]

{ #category : 'removing' }
BearingLinesTheodoliteMobileLabRudesheim >> removeLast [
	|
		result
	|

	result := super removeLast.

	self warning
		value:	#(  ).

	^ result.
]

{ #category : 'accessing' }
BearingLinesTheodoliteMobileLabRudesheim >> warning [
	^ warning.
]

{ #category : 'accessing' }
BearingLinesTheodoliteMobileLabRudesheim >> warning: aNewValueHolder [
	warning := aNewValueHolder.
]
