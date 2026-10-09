"
A StartupScriptExportMobileLabRudesheim makes an exported app's startup.st start the app: it appends
the line `<the app's Application class> startup.` to the end of that file (the Export as App's own
startup.st only hides the development chrome). The line is built from the class the app answers to
`Application`, so renaming the class cannot leave a stale name behind.

startup.st is looked for in the exported project's directory and in each directory directly under it,
because which directory holds it (`Resources`, ...) is iospharo's business, not this class's; it
must be exactly one file. The line is added only if no line of the file is already that line.
"
Class {
	#name : 'StartupScriptExportMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Export',
	#package : 'Rudesheim-MobileLab',
	#tag : 'Export'
}

{ #category : 'preparing' }
StartupScriptExportMobileLabRudesheim class >> prepareAt: aDirectoryFileReference
for: anAppTExportableMobileLabRudesheim [
	|
		startupFiles
		startupFile
		startupCall
		contents
	|

	startupFiles :=
		aDirectoryFileReference files ,
		(
			aDirectoryFileReference directories
				flatCollect:
				[ :each |
					each files.
				]
		)
			select:
			[ :each |
				'startup.st' = each basename.
			].

	1 = startupFiles size
		ifFalse:
		[
			^ self
				error:	'Expected exactly one startup.st under ' , aDirectoryFileReference pathString , ' but found ' , startupFiles size printString , '.'.
		].

	startupFile := startupFiles first.
	startupCall := anAppTExportableMobileLabRudesheim Application name , ' startup.'.
	contents := startupFile contents.

	(
		contents lines
			anySatisfy:
			[ :each |
				startupCall = each trimmed.
			]
	)
		ifTrue:
		[
			^ startupFile.
		].

	startupFile
		ensureDelete;
		writeStreamDo:
		[ :aStream |
			aStream
				nextPutAll:	contents trimRight , String lf , startupCall , String lf.
		].

	^ startupFile.
]
