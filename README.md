# Rudesheim MobileLab for Pharo

[![Pharo 13](https://img.shields.io/badge/Pharo-13-informational)](https://pharo.org)

Rudesheim MobileLab is a mixed dumping ground (a "闇鍋", hot-pot-of-whatever-is-on-hand) for
mobile-device Pharo application prototypes. Unlike the other `*-Rudesheim-Pharo` repositories,
it is intentionally not a single-purpose domain library: it exists to hold short-lived,
unrelated experiments (e.g. an iOS heading-triangulation app) under one roof instead of each
prototype needing its own repository.

**Status: namespace only, no prototype implementation yet.** This repository currently defines
just the `MobileLabRudesheim` namespace class and its accessor from `Rudesheim`.

## Installation

Load the default project group with Metacello:

```smalltalk
Metacello new
	baseline: 'RudesheimMobileLab';
	repository: 'github://devid-rudesheim/MobileLab-Rudesheim-Pharo:main';
	load
```

This also loads the required `RudesheimKernel` and `RudesheimUtility` dependencies from GitHub.

## Requirements

- Pharo with Metacello.

## Dependencies

The baseline loads these repositories:

- `RudesheimKernel`: `github://devid-rudesheim/Kernel-Rudesheim-Pharo:main`
- `RudesheimUtility`: `github://devid-rudesheim/Utility-Rudesheim-Pharo:main`

## Groups

- `#core`: `Rudesheim-MobileLab`
- `#tests`: `Rudesheim-MobileLab-Tests`
- `#default`: `#core`

## Development

Load the `tests` group to run the unit tests:

```smalltalk
Metacello new
	baseline: 'RudesheimMobileLab';
	repository: 'github://devid-rudesheim/MobileLab-Rudesheim-Pharo:main';
	load: #('tests')
```

Tests also run through the [Rudesheim-Pharo](https://github.com/devid-rudesheim/Rudesheim-Pharo)
aggregator, which loads this repository alongside the other Rudesheim repositories.
