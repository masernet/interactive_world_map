# interactive_world_map

Interactive world map widget for Flutter with pre-generated geometry, fast paint,
and simple country hit-testing. Designed for quick selection, highlighting, and
fit-to-region workflows without runtime SVG parsing.

## Features
- Pre-generated world map geometry (no SVG parsing at paint time)
- `InteractiveWorldMap` with pan/zoom via `InteractiveViewer`
- Country hit-testing by map ID (mostly ISO alpha-2, with `X_*` specials)
- UN Geoscheme helpers for region/subregion selection
- Remote-island presets for sane fit bounds
- `WorldIcon` for fixed-size icons

## Getting Started

Add the dependency:
```yaml
dependencies:
  interactive_world_map: ^0.1.0
```

Import:
```dart
import 'package:interactive_world_map/interactive_world_map.dart';
```

## Quick Start

```dart
final controller = WorldMapController();

InteractiveWorldMap(
  controller: controller,
  selectOnTap: true,
  toggleSelectionOnTap: true,
  onCountryTap: (id) {
    // Your app logic here.
  },
  style: const WorldMapStyle(),
)
```

### Fit To Countries

```dart
controller.fitToCountries(
  {CountryCode.FR, CountryCode.DE}.toMapIds(),
  options: const FitOptions(
    excludeRemoteIslands: true,
    remoteIslandLevel: RemoteIslandLevel.main,
  ),
);
```

## Remote-Islands Presets

Remote islands can distort bounds (e.g. Norway/Spitsbergen, USA/Hawaii).
Use presets to get stable fits.

Defaults are already included via `kDefaultRemoteIslandPresetStore`.

### Override a Country
```dart
final options = FitOptions(
  excludeRemoteIslands: true,
  remoteIslandLevel: RemoteIslandLevel.main,
  presetOverrides: {
    // Norway (map id resolves to X_NOR)
    'NO': {
      RemoteIslandLevel.main: const RemoteIslandPreset(
        linkFactor: 0.05,
        minClusterDensityRatio: 0.45,
        maxClustersToKeep: 1,
      ),
    },
  },
);
```

### Force All Parts For One Country
```dart
final options = FitOptions(
  excludeRemoteIslands: true,
  remoteIslandLevel: RemoteIslandLevel.main,
  presetOverrides: {
    // Include all parts even when excludeRemoteIslands is true
    'DK': {RemoteIslandLevel.allParts: const RemoteIslandPreset()},
  },
);
```

## Subset Rendering

Render and hit-test only a subset of countries:
```dart
InteractiveWorldMap(
  visibleCountryIds: UnRegion.europe.mapIds(),
)
```

## UN Geoscheme Helpers

```dart
final europe = UnRegion.europe.mapIds();
final seAsia = UnSubregion.southEasternAsia.mapIds();
final caribbean = UnIntermediateRegion.caribbean.mapIds();
```

## World Icons

```dart
WorldIcon(
  ids: {CountryCode.DE}.toMapIds(),
  size: 64,
  style: const WorldIconStyle(),
)
```

With remote-island filtering:
```dart
WorldIcon(
  ids: {CountryCode.US}.toMapIds(),
  size: 64,
  islandOptions: const IslandFilterOptions(
    excludeRemoteIslands: true,
    remoteIslandLevel: RemoteIslandLevel.main,
  ),
)
```

## ID Mapping

Most map IDs are ISO alpha-2, but some use `X_*` IDs. The default resolver
handles known overrides:

```dart
final id = defaultMapIdResolver('FR'); // -> X_FRA
```

Use `CountryCode` enums and `toMapIds()` helpers to avoid manual mapping.

## Attribution

World map data is derived from Natural Earth and is in the public domain.
Attribution is not required but is appreciated (see `NOTICE`).

## Example App

See `/example` for a working demo with:
- Interactive map selection
- Fit-to-selection
- World icon examples
