"
A BearingLinesTheodoliteMobileLabRudesheim holds the recorded BearingLine collection (up to
#maxSize, 3). It overrides the standard Collection protocol #add:/#removeLast rather than
introducing new selectors, per note/ios-triangulation-app.md section 7.3 (NocoDB Sections 項番FM):

- #add: past capacity never records a 4th line; it announces
  LaunchRequestedTheodoliteMobileLabRudesheim instead.
- #add: below capacity checks the new line actually intersects every already-recorded line
  (rejecting near-parallel lines) and keeps the shared warning holder (set by the owning Model,
  see #warning:) in sync either way -- this is the one piece of coordination the design calls out
  as living inside #add: itself, not through separate Model-level observation.
- #intersectionPoint / #mapURL are 0-or-1-element-array query methods (never nil, per the
  project's no-nil convention) computed on demand from the current lines, not cached.
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
BearingLinesTheodoliteMobileLabRudesheim >> add: aBearingLine [
	self size >= self class maxSize
		ifTrue:
		[
			self announcer
				announce:	Rudesheim MobileLab Theodolite LaunchRequested new.

			^ aBearingLine.
		].

	(
		self
			allSatisfy:
			[ :existing |
				(
					existing ray
						intersectionsWith:	aBearingLine ray
				) isNotEmpty.
			]
	)
		ifFalse:
		[
			self warning
				value:
				{
					Rudesheim MobileLab Theodolite Warning
						message:	'この線は既存の線とほぼ平行で交差しないため追加できません'
				}.

			^ aBearingLine.
		].

	self warning
		value:	#(  ).

	^ super
		add:	aBearingLine.
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
		sumX
		sumY
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
						) ray
							intersectionsWith:
							(
								lines
									at:	j
							) ray
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

	sumX :=
	(
		points
			collect:
			[ :point |
				point x.
			]
	) sum.

	sumY :=
	(
		points
			collect:
			[ :point |
				point y.
			]
	) sum.

	^
	{
		( sumX / points size ) , ( sumY / points size )
	}.
]

{ #category : 'geometry' }
BearingLinesTheodoliteMobileLabRudesheim >> mapURL [
	"0-or-1 array: an Apple Maps 'maps://' URL string for #intersectionPoint. A plain String for
	now -- wrapping it in something that responds to #launch is left to the View/action-block
	layer (out of scope this round, see note/ios-triangulation-app.md 項番FJ item 4)."
	^ self intersectionPoint
		collect:
		[ :point |
			'maps://?ll=' , point y printString , ',' , point x printString.
		].
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
