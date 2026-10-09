"
An InfoPlistExportMobileLabRudesheim adds to an exported app's Info.plist the usage descriptions of
the permissions the app answers to `permissions`: for each permission, `<key>` (what
`permission forPList key` answers) and `<string>` (its `description`, escaped) are put at the end of
the root dictionary. A permission whose key is already in the file is left alone, so a description
somebody already wrote there is never overwritten, and an app with no permissions leaves the file
untouched.

The file is edited as text, not parsed: it is a few lines that Export as App writes in a fixed shape
(the root `</dict>` right before `</plist>`), and a missing or different shape is an error rather
than a guess.
"
Class {
	#name : 'InfoPlistExportMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Export',
	#package : 'Rudesheim-MobileLab',
	#tag : 'Export'
}

{ #category : 'preparing' }
InfoPlistExportMobileLabRudesheim class >> prepareAt: aDirectoryFileReference
for: aTargetTExportableMobileLabRudesheim [
	|
		infoPlistFile
		contents
		missingPermissions
		closingIndex
		beforeClosing
	|

	infoPlistFile := aDirectoryFileReference / 'Info.plist'.

	infoPlistFile exists
		ifFalse:
		[
			^ self
				error:	'Info.plist not found in ' , aDirectoryFileReference pathString , '.'.
		].

	contents := infoPlistFile contents.

	missingPermissions :=
		aTargetTExportableMobileLabRudesheim permissions
			reject:
			[ :each |
				contents
					includesSubstring:	'<key>' , each forPList key , '</key>'.
			].

	missingPermissions isEmpty
		ifTrue:
		[
			^ infoPlistFile.
		].

	closingIndex :=
		contents
			indexOfSubCollection:	'</plist>'.

	0 = closingIndex
		ifTrue:
		[
			^ self
				error:	'No </plist> in ' , infoPlistFile pathString , '.'.
		].

	beforeClosing :=
	(
		contents
			first:	closingIndex - 1
	) trimRight.

	(
		beforeClosing
			endsWith:	'</dict>'
	)
		ifFalse:
		[
			^ self
				error:	'No root </dict> right before </plist> in ' , infoPlistFile pathString , '.'.
		].

	infoPlistFile
		ensureDelete;
		writeStreamDo:
		[ :aStream |
			aStream
				nextPutAll:
				(
					beforeClosing
						allButLast:	'</dict>' size
				);
				nextPutAll:
				(
					String
						streamContents:
						[ :aWriteStream |
							missingPermissions
								do:
								[ :each |
									aWriteStream
										nextPutAll:	'    <key>';
										nextPutAll:	each forPList key;
										nextPutAll:	'</key>';
										nextPutAll:	String lf;
										nextPutAll:	'    <string>';
										nextPutAll:	each description asHTMLString;
										nextPutAll:	'</string>';
										nextPutAll:	String lf.
								].
						]
				);
				nextPutAll:	'</dict>';
				nextPutAll:	String lf;
				nextPutAll:
				(
					contents
						allButFirst:	closingIndex - 1
				).
		].

	^ infoPlistFile.
]
