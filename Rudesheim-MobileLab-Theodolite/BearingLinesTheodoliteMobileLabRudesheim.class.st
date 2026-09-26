"
A BearingLinesTheodoliteMobileLabRudesheim holds the recorded bearing lines, each a plain GRay
(see the GRay class-side extension #origin:normalizedBearing: in Rudesheim-MobileLab), up to
#maxSize, 3. It
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
- #removeLast is a no-op, not an error, when the collection is already empty -- #removeLineButton's
  action calls it unconditionally with no count guard, so pressing it with nothing recorded must
  not crash. It used to raise a `CollectionIsEmpty` error instead; fixed alongside the exhaustive
  interface test suite that caught it (NoteHistory has the details).
- #warning defaults itself lazily to a fresh, empty NewValueHolder (per
  ~/.claude/CLAUDE.md's Smalltalk-specific default-to-lazy-initialization rule, same as
  ModelTheodoliteMobileLabRudesheim's own accessors) rather than requiring #warning: to be sent
  first -- a bare `new` instance (not built through
  ModelTheodoliteMobileLabRudesheim>>#defaultBearingLines) is otherwise unusable: every #add: path
  touches #warning, including the success path, so it used to raise `nil doesNotUnderstand:
  #value:` on its very first #add:. #warning: still overrides the default when the owning Model
  supplies its own shared holder, as it always does today.

Reads that CollectionValueHolder does not implement directly (#asArray/#allSatisfy:/#ifEmpty: --
only reachable at runtime via its #doesNotUnderstand: forwarding to `value`, the wrapped
OrderedCollection) go through `self value` explicitly instead of bare `self`, so the browser does
not flag them as possibly-not-understood; #add:/#removeLast/#size/#warning are real methods here
(declared on this class or CollectionValueHolder itself), so those stay as plain `self` sends.

There is no #push/#pop wrapping #add:/#removeLast with the OS-dispatch position/heading read
(`Smalltalk os rudesheim location currentRay`) baked in -- that read is slow (up to ~50 seconds,
see MacOSLocationRudesheim's comment) and its own caller, the 'Add line' button's Spec2 action
block, needs to disable/re-enable the add/remove buttons around it (see
SpecBuilderTheodoliteMobileLabRudesheim's comment), which only that action block can do -- so it
owns the `#future`/button-disabling entirely and calls #add:/#removeLast directly on this class with
a GRay it already has, the same as a test supplying a synthetic one via
`GRay origin:normalizedBearing:`.
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
		self value
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

	lines := self value asArray.
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
	Actually opening it is the View/action-block layer's concern, via
	`Smalltalk os rudesheim launcher open:` (see OSLauncherRudesheim's comment) -- not this class."
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
BearingLinesTheodoliteMobileLabRudesheim >> removeLast [
	|
		result
	|

	self value
		ifEmpty:
		[
			^ self.
		].

	result := super removeLast.

	self warning
		value:	#(  ).

	^ result.
]

{ #category : 'private' }
BearingLinesTheodoliteMobileLabRudesheim >> defaultWarning [
	^ NewValueHolder
		value:	#(  ).
]

{ #category : 'accessing' }
BearingLinesTheodoliteMobileLabRudesheim >> warning [
	^ warning
		ifNil:
		[
			warning := self defaultWarning.
		].
]

{ #category : 'accessing' }
BearingLinesTheodoliteMobileLabRudesheim >> warning: aNewValueHolder [
	warning := aNewValueHolder assertNotNilRudesheim.
]
