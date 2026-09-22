"
A ModelTheodoliteMobileLabRudesheim is Theodolite's single state-holding object, reached as
`Rudesheim MobileLab Theodolite Model new`. Per note/ios-triangulation-app.md section 7.3 (NocoDB
Sections 項番FM) it keeps exactly two persistent entries, keyed by the dedicated key classes under
`Rudesheim MobileLab Theodolite Key` (KeyTheodoliteMobileLabRudesheim's comment) -- not by the
value-holding classes themselves:
- Key BearingLines -> a BearingLinesTheodoliteMobileLabRudesheim, holding the recorded lines (up to
  3) as plain GRay instances directly (no separate BearingLine wrapper -- nothing needs the bearing
  degrees or a timestamp once the ray exists, and GRay's own #initialPoint/#directionPoint already
  cover what #add:/#intersectionPoint need)
- Key Warning -> a NewValueHolder holding the current 0-or-1-element array of message Strings (no
  wrapper class -- there is nothing for one to add beyond the message itself)

There is deliberately no Controller class: every operation (adding a line, opening/copying the
map URL, discarding everything) is either a standard Collection/Dictionary-protocol call, one of
BearingLinesTheodoliteMobileLabRudesheim's own #push:heading:/#pop, or #discardAll below, called
directly from view action blocks. Adding a line is #bearingLines push:heading: directly -- there is
no Model-level wrapper for it (see BearingLinesTheodoliteMobileLabRudesheim's comment).

Both entries are created lazily (on first #bearingLines/#warning read) rather than eagerly in
#initialize, per ~/.claude/CLAUDE.md's Smalltalk-specific default-to-lazy-initialization rule.
"
Class {
	#name : 'ModelTheodoliteMobileLabRudesheim',
	#superclass : 'DictionaryValueHolder',
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'accessing' }
ModelTheodoliteMobileLabRudesheim >> bearingLines [
	^ self
		at:	Rudesheim MobileLab Theodolite Key BearingLines
		ifAbsentPut:
		[
			self defaultBearingLines.
		].
]

{ #category : 'private' }
ModelTheodoliteMobileLabRudesheim >> defaultBearingLines [
	^ Rudesheim MobileLab Theodolite BearingLines new
		warning:	self warning;
		yourself.
]

{ #category : 'private' }
ModelTheodoliteMobileLabRudesheim >> defaultWarning [
	^ NewValueHolder
		value:	#(  ).
]

{ #category : 'actions' }
ModelTheodoliteMobileLabRudesheim >> discardAll [
	self bearingLines removeAll.

	self warning
		value:	#(  ).
]

{ #category : 'accessing' }
ModelTheodoliteMobileLabRudesheim >> warning [
	^ self
		at:	Rudesheim MobileLab Theodolite Key Warning
		ifAbsentPut:
		[
			self defaultWarning.
		].
]
