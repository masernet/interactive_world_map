import 'package:flutter_test/flutter_test.dart';
import 'package:interactive_world_map/interactive_world_map.dart';

void main() {
  test('defaultMapIdResolver applies overrides', () {
    expect(defaultMapIdResolver('FR'), 'X_FRA');
    expect(defaultMapIdResolver('NO'), 'X_NOR');
    expect(defaultMapIdResolver('DE'), 'DE');
  });

  test('CountryCode toMapIds uses default resolver', () {
    final ids = {CountryCode.FR, CountryCode.DE}.toMapIds();
    expect(ids.contains('X_FRA'), isTrue);
    expect(ids.contains('DE'), isTrue);
  });

  test('Geoscheme enums mapIds include overrides', () {
    final ids = UnRegion.europe.mapIds();
    expect(ids.contains('X_FRA'), isTrue);
    expect(ids.contains('X_NOR'), isTrue);
  });

  test('WorldMapController normalizes ids and overrides', () {
    final controller = WorldMapController();
    Set<String>? receivedIds;
    FitOptions? receivedOptions;

    controller.attachFitHandler((ids, options) {
      receivedIds = ids;
      receivedOptions = options;
    });

    controller.fitToCountries(
      {'FR', 'NO'},
      options: FitOptions(
        presetOverrides: {
          'NO': {
            RemoteIslandLevel.main: const RemoteIslandPreset(
              minClusterDensityRatio: 0.76,
            ),
          },
        },
        excludeRemoteIslands: true,
        remoteIslandLevel: RemoteIslandLevel.main,
      ),
    );

    expect(receivedIds, isNotNull);
    expect(receivedIds!.contains('X_FRA'), isTrue);
    expect(receivedIds!.contains('X_NOR'), isTrue);
    expect(receivedOptions, isNotNull);
    expect(receivedOptions!.presetOverrides.containsKey('X_NOR'), isTrue);

    controller.dispose();
  });

  test('FitOptions uses default preset store', () {
    const options = FitOptions();
    expect(identical(options.presetStore, kDefaultRemoteIslandPresetStore), isTrue);
  });
}
