"
An ImageExportMobileLabRudesheimTest is a test class for testing `Rudesheim MobileLab Export Image`.
`prepareFor:extent:` itself cannot be run here (it empties the real World, irreversibly), so what
it and #startUp: are made of is tested piece by piece, on a World of its own (`WorldMorph new`)
and on bare SpAthensMorph instances.
"
Class {
	#name : 'ImageExportMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
ImageExportMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Export Image.
]

{ #category : 'running' }
ImageExportMobileLabRudesheimTest >> tearDown [
	(
		SessionManager default
			hasRegistered:	self targetClass name
	)
		ifTrue:
		[
			SessionManager default
				unregisterClassNamed:	self targetClass name.
		].

	super tearDown.
]

{ #category : 'tests' }
ImageExportMobileLabRudesheimTest >> testNamespaceReachesTheClass [
	self
		assert:	Rudesheim MobileLab Export Image
		equals:	ImageExportMobileLabRudesheim.
]

{ #category : 'tests' }
ImageExportMobileLabRudesheimTest >> testRefitMorphsOfSetsEveryMorphToTheWorldBounds [
	|
		world
		first
		second
	|

	world := WorldMorph new.

	world
		bounds:
		(
			0 @ 0
				extent:	402 @ 874
		).

	first := Morph new.

	first
		bounds:
		(
			0 @ 0
				extent:	50 @ 40
		).

	second := Morph new.

	second
		bounds:
		(
			10 @ 10
				extent:	5 @ 5
		).

	world
		addMorph:	first;
		addMorph:	second.

	self targetClass
		refitMorphsOf:	world.

	self
		assert:	first bounds
		equals:	world bounds.

	self
		assert:	second bounds
		equals:	world bounds.
]

{ #category : 'tests' }
ImageExportMobileLabRudesheimTest >> testRegisterIsIdempotent [
	|
		handlers
	|

	self targetClass register.
	self targetClass register.

	handlers :=
		SessionManager default systemCategory prioritizedList
			select:
			[ :aHandler |
				aHandler
					isKindOf:	ClassSessionHandler.
			].

	self
		assert:
		(
			handlers
				count:
				[ :aHandler |
					aHandler registeredClass == self targetClass.
				]
		)
		equals:	1.
]

{ #category : 'tests' }
ImageExportMobileLabRudesheimTest >> testResetSurfaceOfClearsARecordedDrawError [
	|
		morph
	|

	morph := SpAthensMorph new.

	morph
		setProperty:	#errorOnDraw
		toValue:	true.

	self targetClass
		resetSurfaceOf:	morph.

	self
		deny:
		(
			morph
				hasProperty:	#errorOnDraw
		).
]

{ #category : 'tests' }
ImageExportMobileLabRudesheimTest >> testResetSurfaceOfDropsTheSurface [
	|
		morph
	|

	morph := SpAthensMorph new.

	morph
		extent:	100 @ 100;
		drawBlock:
		[ :aCanvas |
		].

	morph surface.

	self
		deny:
		(
			morph
				instVarNamed:	#surface
		) isNil.

	self targetClass
		resetSurfaceOf:	morph.

	self
		assert:
		(
			morph
				instVarNamed:	#surface
		) isNil.
]

{ #category : 'tests' }
ImageExportMobileLabRudesheimTest >> testStartUpWhenNotStartingChangesNothing [
	|
		morph
	|

	morph := SpAthensMorph new.

	morph
		extent:	100 @ 100;
		drawBlock:
		[ :aCanvas |
		].

	morph surface.

	self targetClass
		startUp:	false.

	self
		deny:
		(
			morph
				instVarNamed:	#surface
		) isNil.
]
