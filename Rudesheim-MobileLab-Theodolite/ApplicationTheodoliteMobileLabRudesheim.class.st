"
An ApplicationTheodoliteMobileLabRudesheim is the SpApplication for Theodolite, the iOS
bearing-line triangulation prototype (resection from three recorded bearings, see
note/ios-triangulation-app.md in the main project repository). Reached as
`Rudesheim MobileLab Theodolite Application`.

`start` builds the Model; it does not yet open a window. The portrait/landscape View presenters
(note/ios-triangulation-app.md section 2) and the ObjC-bridge location/heading sourcing (section 8
item 4) are separate, not-yet-built work -- see `SpecBuilderTheodoliteMobileLabRudesheim`'s
comment. Once a View exists, `start` wires it with
`Rudesheim MobileLab Theodolite SpecBuilder bindModel:toView:`.
"
Class {
	#name : 'ApplicationTheodoliteMobileLabRudesheim',
	#superclass : 'SpApplication',
	#instVars : [
		'model'
	],
	#category : 'Rudesheim-MobileLab-Theodolite',
	#package : 'Rudesheim-MobileLab-Theodolite'
}

{ #category : 'accessing' }
ApplicationTheodoliteMobileLabRudesheim >> model [
	^ model.
]

{ #category : 'starting' }
ApplicationTheodoliteMobileLabRudesheim >> start [
	model := Rudesheim MobileLab Theodolite Model new.
]
