import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'fit/remote_island_presets.dart';
import 'geoscheme/map_id_resolver.dart';

typedef FitHandler = void Function(Set<String> ids, FitOptions options);

@immutable
class FitOptions {
  const FitOptions({
    this.padding = 16,
    this.duration,
    this.curve = Curves.easeInOut,
    this.excludeRemoteIslands = false,
    this.remoteIslandLevel = RemoteIslandLevel.allParts,
    this.presetStore = kDefaultRemoteIslandPresetStore,
    this.presetOverrides = const {},
  });

  final double padding;
  final Duration? duration;
  final Curve curve;

  final bool excludeRemoteIslands;
  final RemoteIslandLevel remoteIslandLevel;
  final RemoteIslandPresetStore presetStore;
  final Map<String, Map<RemoteIslandLevel, RemoteIslandPreset>>
      presetOverrides;

  RemoteIslandPreset? presetForCountry(String id) {
    if (!excludeRemoteIslands ||
        remoteIslandLevel == RemoteIslandLevel.allParts) {
      return null;
    }
    final perCountry = presetOverrides[id];
    if (perCountry != null) {
      if (perCountry.length == 1 &&
          perCountry.containsKey(RemoteIslandLevel.allParts)) {
        return null;
      }
      final override = perCountry[remoteIslandLevel];
      if (override != null) return override;
    }
    return presetStore.getPreset(id, remoteIslandLevel);
  }

  FitOptions copyWith({
    double? padding,
    Duration? duration,
    Curve? curve,
    bool? excludeRemoteIslands,
    RemoteIslandLevel? remoteIslandLevel,
    RemoteIslandPresetStore? presetStore,
    Map<String, Map<RemoteIslandLevel, RemoteIslandPreset>>? presetOverrides,
  }) {
    return FitOptions(
      padding: padding ?? this.padding,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      excludeRemoteIslands: excludeRemoteIslands ?? this.excludeRemoteIslands,
      remoteIslandLevel: remoteIslandLevel ?? this.remoteIslandLevel,
      presetStore: presetStore ?? this.presetStore,
      presetOverrides: presetOverrides ?? this.presetOverrides,
    );
  }
}

class WorldMapController extends ChangeNotifier {
  WorldMapController({TransformationController? transformationController})
    : transformationController =
          transformationController ?? TransformationController(),
      _ownsTransform = transformationController == null;

  final TransformationController transformationController;
  final bool _ownsTransform;

  String? _selectedId;
  String? get selectedId => _selectedId;
  set selectedId(String? value) {
    if (_selectedId == value) return;
    _selectedId = value;
    notifyListeners();
  }

  Set<String> _highlightedIds = <String>{};
  Set<String> get highlightedIds => _highlightedIds;
  set highlightedIds(Set<String> value) {
    _highlightedIds = value.toSet();
    notifyListeners();
  }

  FitHandler? _fitHandler;

  @internal
  void attachFitHandler(FitHandler? handler) {
    _fitHandler = handler;
  }

  void fitToCountries(
    Set<String> ids, {
    FitOptions options = const FitOptions(),
    MapIdResolver mapIdResolver = defaultMapIdResolver,
  }) {
    final mappedIds = _normalizeIds(ids, mapIdResolver);
    final mappedOptions = _normalizeFitOptions(options, mapIdResolver);
    _fitHandler?.call(mappedIds, mappedOptions);
  }

  Set<String> _normalizeIds(Set<String> ids, MapIdResolver resolver) {
    if (ids.isEmpty) return const <String>{};
    final out = <String>{};
    for (final id in ids) {
      final mapped = resolver(id);
      if (mapped != null) out.add(mapped);
    }
    return out;
  }

  FitOptions _normalizeFitOptions(
    FitOptions options,
    MapIdResolver resolver,
  ) {
    final mappedOverrides =
        _normalizePresetOverrides(options.presetOverrides, resolver);
    final mappedStore = options.presetStore.mapKeys(resolver);
    if (mappedOverrides == options.presetOverrides &&
        identical(mappedStore, options.presetStore)) {
      return options;
    }
    return options.copyWith(
      presetOverrides: mappedOverrides,
      presetStore: mappedStore,
    );
  }

  Map<String, Map<RemoteIslandLevel, RemoteIslandPreset>>
      _normalizePresetOverrides(
    Map<String, Map<RemoteIslandLevel, RemoteIslandPreset>> overrides,
    MapIdResolver resolver,
  ) {
    if (overrides.isEmpty) return overrides;
    final out = <String, Map<RemoteIslandLevel, RemoteIslandPreset>>{};
    for (final e in overrides.entries) {
      final key = resolver(e.key) ?? e.key;
      final existing = out[key];
      if (existing == null) {
        out[key] = Map<RemoteIslandLevel, RemoteIslandPreset>.from(e.value);
      } else {
        out[key] = <RemoteIslandLevel, RemoteIslandPreset>{
          ...existing,
          ...e.value,
        };
      }
    }
    return out;
  }

  @override
  void dispose() {
    if (_ownsTransform) {
      transformationController.dispose();
    }
    super.dispose();
  }
}
