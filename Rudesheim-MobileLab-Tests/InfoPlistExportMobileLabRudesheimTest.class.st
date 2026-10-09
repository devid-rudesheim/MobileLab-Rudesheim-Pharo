"
An InfoPlistExportMobileLabRudesheimTest is a test class for testing
`Rudesheim MobileLab Export InfoPlist`. The exported project is a directory of an in-memory file
system holding an Info.plist of the shape Export as App writes (seven lines, no newline at the end),
which is what `exportDirectory` answers.
"
Class {
	#name : 'InfoPlistExportMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#instVars : [
		'exportDirectory'
	],
	#category : 'Rudesheim-MobileLab-Tests',
	#package : 'Rudesheim-MobileLab-Tests'
}

{ #category : 'accessing' }
InfoPlistExportMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Export InfoPlist.
]

{ #category : 'private' }
InfoPlistExportMobileLabRudesheimTest >> defaultExportDirectory [
	|
		directory
		infoPlistFile
	|

	directory := FileSystem memory root / 'Exported'.
	infoPlistFile := directory / 'Info.plist'.

	infoPlistFile
		ensureCreateFile;
		writeStreamDo:
		[ :aStream |
			aStream
				nextPutAll:
				(
					String lf
						join:
						#(
							'<?xml version="1.0" encoding="UTF-8"?>'
							'<plist version="1.0">'
							'<dict>'
							'    <key>CFBundleName</key>'
							'    <string>Fixture</string>'
							'</dict>'
							'</plist>'
						)
				).
		].

	^ directory.
]

{ #category : 'accessing' }
InfoPlistExportMobileLabRudesheimTest >> exportDirectory [
	^ exportDirectory
		ifNil:
		[
			exportDirectory := self defaultExportDirectory.
		].
]

{ #category : 'accessing' }
InfoPlistExportMobileLabRudesheimTest >> exportDirectory: aFileReference [
	exportDirectory := aFileReference.
]

{ #category : 'running' }
InfoPlistExportMobileLabRudesheimTest >> setUp [
	super setUp.

	self
		exportDirectory:	nil.
]

{ #category : 'tests' }
InfoPlistExportMobileLabRudesheimTest >> testPrepareAddsEveryPermissionOfTheAppAndEscapesItsDescription [
	|
		contents
	|

	self targetClass
		prepareAt:	self exportDirectory
		for:	Rudesheim MobileLab Export StubApp.

	contents := ( self exportDirectory / 'Info.plist' ) contents.

	self
		assert:
		(
			contents
				includesSubstring:	'    <key>NSLocationWhenInUseUsageDescription</key>' , String lf , '    <string>This app uses your location.</string>'
		).

	self
		assert:
		(
			contents
				includesSubstring:	'    <key>StubUsageDescription</key>' , String lf , '    <string>Stub &amp; &lt;test&gt;</string>'
		).
]

{ #category : 'tests' }
InfoPlistExportMobileLabRudesheimTest >> testPrepareEndsTheRootDictionaryAfterTheNewEntries [
	self targetClass
		prepareAt:	self exportDirectory
		for:	Rudesheim MobileLab Export StubApp.

	self
		assert:
		(
			(
				self exportDirectory / 'Info.plist'
			) contents
				endsWith:	'</string>' , String lf , '</dict>' , String lf , '</plist>'
		).
]

{ #category : 'tests' }
InfoPlistExportMobileLabRudesheimTest >> testPrepareIsIdempotent [
	|
		infoPlistFile
		afterFirstPrepare
	|

	infoPlistFile := self exportDirectory / 'Info.plist'.

	self targetClass
		prepareAt:	self exportDirectory
		for:	Rudesheim MobileLab Export StubApp.

	afterFirstPrepare := infoPlistFile contents.

	self targetClass
		prepareAt:	self exportDirectory
		for:	Rudesheim MobileLab Export StubApp.

	self
		assert:	infoPlistFile contents
		equals:	afterFirstPrepare.
]

{ #category : 'tests' }
InfoPlistExportMobileLabRudesheimTest >> testPrepareKeepsTheExistingEntries [
	self targetClass
		prepareAt:	self exportDirectory
		for:	Rudesheim MobileLab Export StubApp.

	self
		assert:
		(
			(
				self exportDirectory / 'Info.plist'
			) contents lines
				first:	5
		)
		equals:
		{
			'<?xml version="1.0" encoding="UTF-8"?>'.
			'<plist version="1.0">'.
			'<dict>'.
			'    <key>CFBundleName</key>'.
			'    <string>Fixture</string>'
		}.
]

{ #category : 'tests' }
InfoPlistExportMobileLabRudesheimTest >> testPrepareLeavesAnExistingDescriptionAlone [
	|
		contents
		infoPlistFile
	|

	infoPlistFile := self exportDirectory / 'Info.plist'.

	infoPlistFile
		ensureDelete;
		writeStreamDo:
		[ :aStream |
			aStream
				nextPutAll:
				(
					String lf
						join:
						#(
							'<plist version="1.0">'
							'<dict>'
							'    <key>NSLocationWhenInUseUsageDescription</key>'
							'    <string>Mine</string>'
							'</dict>'
							'</plist>'
						)
				).
		].

	self targetClass
		prepareAt:	self exportDirectory
		for:	Rudesheim MobileLab Export StubApp.

	contents := ( self exportDirectory / 'Info.plist' ) contents.

	self
		assert:
		(
			contents
				includesSubstring:	'<string>Mine</string>'
		).

	self
		deny:
		(
			contents
				includesSubstring:	'This app uses your location.'
		).
]

{ #category : 'tests' }
InfoPlistExportMobileLabRudesheimTest >> testPrepareLeavesTheFileUnchangedWhenTheAppHasNoPermission [
	|
		before
	|

	before := ( self exportDirectory / 'Info.plist' ) contents.

	self targetClass
		prepareAt:	self exportDirectory
		for:	Rudesheim MobileLab Export StubBareApp.

	self
		assert:
		(
			self exportDirectory / 'Info.plist'
		) contents
		equals:	before.
]

{ #category : 'tests' }
InfoPlistExportMobileLabRudesheimTest >> testPrepareRaisesWhenInfoPlistIsMissing [
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
InfoPlistExportMobileLabRudesheimTest >> testPrepareRaisesWhenTheRootDictionaryDoesNotEndRightBeforePListEnds [
	|
		infoPlistFile
	|

	infoPlistFile := self exportDirectory / 'Info.plist'.

	infoPlistFile
		ensureDelete;
		writeStreamDo:
		[ :aStream |
			aStream
				nextPutAll:
				(
					String lf
						join:
						#(
							'<plist version="1.0">'
							'<dict>'
							'oops'
							'</plist>'
						)
				).
		].

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
InfoPlistExportMobileLabRudesheimTest >> testPrepareRaisesWhenThereIsNoPListEnd [
	|
		infoPlistFile
	|

	infoPlistFile := self exportDirectory / 'Info.plist'.

	infoPlistFile
		ensureDelete;
		writeStreamDo:
		[ :aStream |
			aStream
				nextPutAll:	'not a plist'.
		].

	self
		should:
		[
			self targetClass
				prepareAt:	self exportDirectory
				for:	Rudesheim MobileLab Export StubApp.
		]
		raise:	Error.
]
