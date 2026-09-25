"
A CoordinateParserLocationMobileLabRudesheimTest verifies the CLLocation-description text parse
against real `-description` output captured from actual CLLocation instances (constructed directly
via ObjC, no CoreLocation authorization needed for that -- see note/pharo-ops.md section 41), not
just synthetic strings.
"
Class {
	#name : 'CoordinateParserLocationMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
CoordinateParserLocationMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Location CoordinateParser.
]

{ #category : 'tests' }
CoordinateParserLocationMobileLabRudesheimTest >> testParseCLLocationDescriptionPositiveCoordinates [
	| point |
	point := self targetClass
		parseCLLocationDescription:	'<+35.68123600,+139.76712500> +/- 0.00m (speed -1.00 mps / course -1.00) @ 2026/09/24, 0:01:02 Japan Standard Time'.

	self
		assert:	point x
		closeTo:	139.767125.

	self
		assert:	point y
		closeTo:	35.681236.
]

{ #category : 'tests' }
CoordinateParserLocationMobileLabRudesheimTest >> testParseCLLocationDescriptionNegativeCoordinates [
	| point |
	point := self targetClass
		parseCLLocationDescription:	'<-33.86880000,+151.20930000> +/- 0.00m (speed -1.00 mps / course -1.00) @ 2026/09/24, 0:08:11 Japan Standard Time'.

	self
		assert:	point x
		closeTo:	151.2093.

	self
		assert:	point y
		closeTo:	-33.8688.
]
