"
A TheodoliteMobileLabRudesheimTest is a test class for testing what `Rudesheim MobileLab Theodolite`
answers to the `Rudesheim MobileLab Export` classes (its `Application` and its `permissions`), and
that those classes can prepare an exported project's files with it: the project is a directory of an
in-memory file system.
"
Class {
	#name : 'TheodoliteMobileLabRudesheimTest',
	#superclass : 'BasicRudesheimTest',
	#category : 'Rudesheim-MobileLab-Theodolite-Tests',
	#package : 'Rudesheim-MobileLab-Theodolite-Tests'
}

{ #category : 'accessing' }
TheodoliteMobileLabRudesheimTest class >> targetClass [
	^ Rudesheim MobileLab Theodolite.
]

{ #category : 'tests' }
TheodoliteMobileLabRudesheimTest >> testInfoPlistPreparationAsksForTheLocationUsageDescription [
	|
		directory
		contents
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
							'<plist version="1.0">'
							'<dict>'
							'</dict>'
							'</plist>'
						)
				).
		].

	Rudesheim MobileLab Export InfoPlist
		prepareAt:	directory
		for:	self targetClass.

	contents := ( directory / 'Info.plist' ) contents.

	self
		assert:
		(
			contents
				includesSubstring:	'<key>NSLocationWhenInUseUsageDescription</key>'
		).

	self
		assert:
		(
			contents
				includesSubstring:	self targetClass permissions first description
		).
]

{ #category : 'tests' }
TheodoliteMobileLabRudesheimTest >> testPermissionsAreTheLocationService [
	self
		assert:
		(
			self targetClass permissions
				collect:
				[ :each |
					each class.
				]
		)
		equals:
		{
			Rudesheim MobileLab Permission LocationService
		}.
]

{ #category : 'tests' }
TheodoliteMobileLabRudesheimTest >> testPermissionsDescribeWhyTheAppNeedsThem [
	self targetClass permissions
		do:
		[ :each |
			self
				assert:
				(
					each description
						includesSubstring:	'Theodolite'
				).
		].
]

{ #category : 'tests' }
TheodoliteMobileLabRudesheimTest >> testStartupScriptPreparationCallsTheApplicationStartup [
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
				nextPutAll:	'Smalltalk beep.'.
		].

	Rudesheim MobileLab Export StartupScript
		prepareAt:	directory
		for:	self targetClass.

	self
		assert:
		(
			directory / 'PharoFiles' / 'startup.st'
		) contents lines last
		equals:	'ApplicationTheodoliteMobileLabRudesheim startup.'.
]
