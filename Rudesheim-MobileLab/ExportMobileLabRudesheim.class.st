"
An ExportMobileLabRudesheim is the namespace of the work a MobileLab app needs after the iospharo
app's `Export as App` has written its Xcode project: `Rudesheim MobileLab Export StartupScript` and
`Rudesheim MobileLab Export InfoPlist`. Each of them is stateless and answers
`prepareAt: aDirectoryFileReference for: anAppClass`, where the first argument is the exported
project's directory and the second is the app's own namespace class (e.g.
`Rudesheim MobileLab Theodolite`), which is asked only for what it needs:

	`Application`	the app's SpApplication class (it answers the class-side #startup)
	`permissions`	the Rudesheim MobileLab Permission objects the app needs (empty when none)

Every `prepareAt:for:` can be run again on an already prepared project and then changes nothing.
This only covers what is specific to the app; anything that is wrong in the exported project
for every app belongs in iospharo's Export itself, not here.
"
Class {
	#name : 'ExportMobileLabRudesheim',
	#superclass : 'Object',
	#category : 'Rudesheim-MobileLab-Namespace',
	#package : 'Rudesheim-MobileLab',
	#tag : 'Namespace'
}

{ #category : 'accessing' }
ExportMobileLabRudesheim class >> InfoPlist [
	^ InfoPlistExportMobileLabRudesheim.
]

{ #category : 'accessing' }
ExportMobileLabRudesheim class >> StartupScript [
	^ StartupScriptExportMobileLabRudesheim.
]
