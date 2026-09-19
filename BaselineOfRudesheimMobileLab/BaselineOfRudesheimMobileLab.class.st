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
						repository:	'github://devid-rudesheim/Kernel-Rudesheim-Pharo:develop'.
				];
				baseline:	'RudesheimUtility'
				with:
				[
					spec
						repository:	'github://devid-rudesheim/Utility-Rudesheim-Pharo:develop'.
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
				group:	#core
				with:	#( 'Rudesheim-MobileLab' );
				group:	#tests
				with:	#( 'Rudesheim-MobileLab-Tests' );
				group:	#default
				with:	#( #core ).
		].
]