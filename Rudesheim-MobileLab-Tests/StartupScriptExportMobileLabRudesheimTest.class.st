"
A StartupScriptExportMobileLabRudesheimTest is a test class for testing
`Rudesheim MobileLab Export StartupScript`. The exported project is a directory of an in-memory file
system: `PharoFiles/startup.st` with two lines, which is what `exportDirectory` answers.
"
Class {
	#name : 'StartupScriptExportMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#instVars : [
		'exportDirectory'
	],
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
StartupScriptExportMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Export StartupScript.
]

{ #category : 'private' }
StartupScriptExportMobileLabRudesheimTest >> defaultExportDirectory [
	|
		directory
		startupFile
	|

	directory := FileSystem memory root / 'Exported'.
	startupFile := directory / 'PharoFiles' / 'startup.st'.

	startupFile
		ensureCreateFile;
		writeStreamDo:
		[ :aStream |
			aStream
				nextPutAll:	'"Auto-generated"' , String lf , 'MenubarMorph showMenubar: false.' , String lf.
		].

	^ directory.
]

{ #category : 'accessing' }
StartupScriptExportMobileLabRudesheimTest >> exportDirectory [
	^ exportDirectory
		ifNil:
		[
			exportDirectory := self defaultExportDirectory.
		].
]

{ #category : 'accessing' }
StartupScriptExportMobileLabRudesheimTest >> exportDirectory: aFileReference [
	exportDirectory := aFileReference.
]

{ #category : 'running' }
StartupScriptExportMobileLabRudesheimTest >> setUp [
	super setUp.

	self
		exportDirectory:	nil.
]

{ #category : 'tests' }
StartupScriptExportMobileLabRudesheimTest >> testPrepareAnswersTheStartupScript [
	self
		assert:
		(
			self targetClass
				prepareAt:	self exportDirectory
				for:	Rudesheim MobileLab Export StubApp
		)
		equals:	self exportDirectory / 'PharoFiles' / 'startup.st'.
]

{ #category : 'tests' }
StartupScriptExportMobileLabRudesheimTest >> testPrepareAppendsTheApplicationStartupCall [
	self targetClass
		prepareAt:	self exportDirectory
		for:	Rudesheim MobileLab Export StubApp.

	self
		assert:
		(
			self exportDirectory / 'PharoFiles' / 'startup.st'
		) contents lines last
		equals:	'StubApplicationExportMobileLabRudesheim startup.'.
]

{ #category : 'tests' }
StartupScriptExportMobileLabRudesheimTest >> testPrepareFindsTheStartupScriptAtTheTopOfTheDirectory [
	|
		directory
		startupFile
	|

	directory := FileSystem memory root / 'TopLevel'.
	startupFile := directory / 'startup.st'.

	startupFile
		ensureCreateFile;
		writeStreamDo:
		[ :aStream |
			aStream
				nextPutAll:	'Smalltalk beep.'.
		].

	self targetClass
		prepareAt:	directory
		for:	Rudesheim MobileLab Export StubApp.

	self
		assert:
		(
			directory / 'startup.st'
		) contents lines last
		equals:	'StubApplicationExportMobileLabRudesheim startup.'.
]

{ #category : 'tests' }
StartupScriptExportMobileLabRudesheimTest >> testPrepareFindsTheStartupScriptInWhicheverDirectoryHoldsIt [
	|
		directory
		startupFile
	|

	directory := FileSystem memory root / 'Renamed'.
	startupFile := directory / 'Resources' / 'startup.st'.

	startupFile
		ensureCreateFile;
		writeStreamDo:
		[ :aStream |
			aStream
				nextPutAll:	'Smalltalk beep.'.
		].

	self targetClass
		prepareAt:	directory
		for:	Rudesheim MobileLab Export StubApp.

	self
		assert:
		(
			directory / 'Resources' / 'startup.st'
		) contents lines last
		equals:	'StubApplicationExportMobileLabRudesheim startup.'.
]

{ #category : 'tests' }
StartupScriptExportMobileLabRudesheimTest >> testPrepareIsIdempotent [
	|
		startupFile
		afterFirstPrepare
	|

	startupFile := self exportDirectory / 'PharoFiles' / 'startup.st'.

	self targetClass
		prepareAt:	self exportDirectory
		for:	Rudesheim MobileLab Export StubApp.

	afterFirstPrepare := startupFile contents.

	self targetClass
		prepareAt:	self exportDirectory
		for:	Rudesheim MobileLab Export StubApp.

	self
		assert:	startupFile contents
		equals:	afterFirstPrepare.
]

{ #category : 'tests' }
StartupScriptExportMobileLabRudesheimTest >> testPrepareKeepsTheExistingLines [
	self targetClass
		prepareAt:	self exportDirectory
		for:	Rudesheim MobileLab Export StubApp.

	self
		assert:
		(
			(
				self exportDirectory / 'PharoFiles' / 'startup.st'
			) contents lines
				first:	2
		)
		equals:
		{
			'"Auto-generated"'.
			'MenubarMorph showMenubar: false.'
		}.
]

{ #category : 'tests' }
StartupScriptExportMobileLabRudesheimTest >> testPrepareRaisesWhenThereAreSeveralStartupScripts [
	(
		self exportDirectory / 'Duplicate' / 'startup.st'
	) ensureCreateFile.

	self
		should:
		[
			self targetClass
				prepareAt:	self exportDirectory
				for:	Rudesheim MobileLab Export StubApp.
		]
		raise:	Error.
]

{ #category : 'tests' }
StartupScriptExportMobileLabRudesheimTest >> testPrepareRaisesWhenThereIsNoStartupScript [
	|
		directory
	|

	directory := FileSystem memory root / 'Empty'.
	directory ensureCreateDirectory.

	self
		should:
		[
			self targetClass
				prepareAt:	directory
				for:	Rudesheim MobileLab Export StubApp.
		]
		raise:	Error.
]

{ #category : 'tests' }
StartupScriptExportMobileLabRudesheimTest >> testPrepareStartsTheCallOnItsOwnLineWhenTheScriptEndsWithoutNewline [
	|
		directory
		startupFile
	|

	directory := FileSystem memory root / 'NoNewline'.
	startupFile := directory / 'PharoFiles' / 'startup.st'.

	startupFile
		ensureCreateFile;
		writeStreamDo:
		[ :aStream |
			aStream
				nextPutAll:	'Smalltalk beep.'.
		].

	self targetClass
		prepareAt:	directory
		for:	Rudesheim MobileLab Export StubApp.

	self
		assert:
		(
			directory / 'PharoFiles' / 'startup.st'
		) contents lines
		equals:
		{
			'Smalltalk beep.'.
			'StubApplicationExportMobileLabRudesheim startup.'
		}.
]
