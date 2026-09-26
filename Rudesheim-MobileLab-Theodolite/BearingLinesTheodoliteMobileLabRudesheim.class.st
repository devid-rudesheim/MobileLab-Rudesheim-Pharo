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
- #removeLast (and its alias #pop) is a no-op, not an error, when the collection is already empty
  -- #removeLineButton's action calls it unconditionally with no count guard, so pressing it with
  nothing recorded must not crash. It used to raise a `CollectionIsEmpty` error instead; fixed
  alongside the exhaustive interface test suite that caught it (NoteHistory has the details).
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

#push/#pop are the view-facing stack-style entry points action blocks actually call: #push reads
the current position/heading from `Smalltalk os rudesheim location currentRay` (Rudesheim-MobileLab's
OS-dispatch mechanism) and passes it through #add:; #pop is a plain alias for #removeLast. A caller
that already has (or can build) a GRay -- e.g. a test supplying a synthetic origin/normalized
bearing via `GRay origin:normalizedBearing:` -- uses #add:/#removeLast directly instead; #add:'s
capacity/intersection
coordination above applies either way.

#push runs `currentRay` on a TaskIt background process (`#future`), not on its caller's own process:
`currentRay` synchronously blocks for up to ~50 seconds (two 25-second `waitUntil:timeoutSeconds:`
polls inside MacOSLocationRudesheim, see its comment) waiting on a CoreLocation delegate callback,
and #push's only real caller is the 'Add line' button's Spec2 action block, which runs on the UI
process -- calling `currentRay` there directly used to freeze the whole UI for the length of the
wait. The future's callbacks (#onSuccessDo:/#onFailureDo:) run #add: or update #warning back on the
UI process via `UIManager default defer:`, since Spec2/Morphic's own display updates (driven by
NewValueHolder's announcer, which both #add: and #warning go through) are UI-process-only, like any
other Morphic mutation. A location/heading failure (timeout or otherwise) surfaces through the
existing #warning mechanism instead of raising into the UI process.
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
BearingLinesTheodoliteMobileLabRudesheim >> pop [
	^ self removeLast.
]

{ #category : 'adding' }
BearingLinesTheodoliteMobileLabRudesheim >> push [
	[
		Smalltalk os rudesheim location currentRay.
	] future
		onSuccessDo:
		[ :aGRay |
			UIManager default
				defer:
				[
					self
						add:	aGRay.
				].
		];
		onFailureDo:
		[ :anError |
			UIManager default
				defer:
				[
					self warning
						value:
						{
							anError messageText
						}.
				].
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
