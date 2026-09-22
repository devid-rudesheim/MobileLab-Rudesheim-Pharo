"
A ModelTheodoliteMobileLabRudesheim is Theodolite's single state-holding object, reached as
`Rudesheim MobileLab Theodolite Model new`. Per note/ios-triangulation-app.md section 7.3 (NocoDB
Sections 項番FM) it keeps exactly two persistent entries, keyed by class:
- BearingLinesTheodoliteMobileLabRudesheim -> itself, holding the recorded lines (up to 3) as
  plain GRay instances directly (no separate BearingLine wrapper -- nothing needs the bearing
  degrees or a timestamp once the ray exists, and GRay's own #initialPoint/#directionPoint already
  cover what #add:/#intersectionPoint need)
- WarningTheodoliteMobileLabRudesheim -> a NewValueHolder holding the current 0-or-1-element
  warning array

There is deliberately no Controller class: every operation (adding a line, opening/copying the
map URL, discarding everything) is either a standard Collection/Dictionary-protocol call or one of
the two composite operations below, called directly from view action blocks.
"
Class {
	#name : 'ModelTheodoliteMobileLabRudesheim',
	#superclass : 'DictionaryValueHolder',
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'adding' }
ModelTheodoliteMobileLabRudesheim >> addLineAt: aGPoint
heading: aNumber [
	self bearingLines
		add:
		(
			GRay
				origin:	aGPoint
				bearing:	aNumber
		).
]

{ #category : 'accessing' }
ModelTheodoliteMobileLabRudesheim >> bearingLines [
	^ self
		at:	Rudesheim MobileLab Theodolite BearingLines.
]

{ #category : 'actions' }
ModelTheodoliteMobileLabRudesheim >> discardAll [
	self bearingLines removeAll.

	self warning
		value:	#(  ).
]

{ #category : 'initialization' }
ModelTheodoliteMobileLabRudesheim >> initialize [
	|
		theodolite
	|

	super initialize.
	theodolite := Rudesheim MobileLab Theodolite.

	self
		at:	theodolite Warning
		put:
		(
			NewValueHolder
				value:	#(  )
		).

	self
		at:	theodolite BearingLines
		put:
		(
			theodolite BearingLines new
				warning:	self warning;
				yourself
		).
]

{ #category : 'accessing' }
ModelTheodoliteMobileLabRudesheim >> warning [
	^ self
		at:	Rudesheim MobileLab Theodolite Warning.
]
