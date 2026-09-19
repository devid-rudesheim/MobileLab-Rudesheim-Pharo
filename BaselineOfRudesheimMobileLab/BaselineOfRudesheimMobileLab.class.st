Class {
	#name : 'BaselineOfRudesheimMobileLab',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRudesheimMobileLab',
	#package : 'BaselineOfRudesheimMobileLab'
}

{ #category : 'baselines' }
BaselineOfRudesheimMobileLab >> baseline: spec [
	<baseline>

	spec
		for:	#common
		do:
		[
			spec
				baseline:	'RudesheimKernel'
				with:
				[
					spec
						repository:	'github://devid-rudesheim/Kernel-Rudesheim-Pharo:main'.
				];
				baseline:	'RudesheimUtility'
				with:
				[
					spec
						repository:	'github://devid-rudesheim/Utility-Rudesheim-Pharo:main'.
				];
				package:	'Rudesheim-MobileLab'
				with:
				[
					spec
						requires:	#( 'RudesheimKernel' 'RudesheimUtility' ).
				];
				package:	'Rudesheim-MobileLab-Tests'
				with:
				[
					spec
						requires:	#( 'Rudesheim-MobileLab' ).
				];
				package:	'Rudesheim-MobileLab-Theodolite'
				with:
				[
					spec
						requires:	#( 'Rudesheim-MobileLab' ).
				];
				package:	'Rudesheim-MobileLab-Theodolite-Tests'
				with:
				[
					spec
						requires:	#( 'Rudesheim-MobileLab-Theodolite' ).
				];
				group:	#core
				with:	#( 'Rudesheim-MobileLab' 'Rudesheim-MobileLab-Theodolite' );
				group:	#tests
				with:	#( 'Rudesheim-MobileLab-Tests' 'Rudesheim-MobileLab-Theodolite-Tests' );
				group:	#default
				with:	#( #core ).
		].
]