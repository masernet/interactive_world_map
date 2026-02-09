import 'package:flutter/foundation.dart';

enum RemoteIslandLevel { allParts, main, mainPlus }

@immutable
class RemoteIslandPreset {
  const RemoteIslandPreset({
    this.linkFactor = 0.75,
    this.minClusterDensityRatio = 0.45,
    this.maxClustersToKeep = 1,
  });

  final double linkFactor;
  final int maxClustersToKeep;
  final double minClusterDensityRatio;

  RemoteIslandPreset copyWith({
    double? linkFactor,
    int? maxClustersToKeep,
    double? minClusterDensityRatio,
  }) {
    return RemoteIslandPreset(
      linkFactor: linkFactor ?? this.linkFactor,
      maxClustersToKeep: maxClustersToKeep ?? this.maxClustersToKeep,
      minClusterDensityRatio:
          minClusterDensityRatio ?? this.minClusterDensityRatio,
    );
  }
}

@immutable
class RemoteIslandPresetStore {
  const RemoteIslandPresetStore({
    this.presets = const {},
    this.defaults = const {
      RemoteIslandLevel.main: RemoteIslandPreset(),
      RemoteIslandLevel.mainPlus: RemoteIslandPreset(),
    },
  });

  final Map<String, Map<RemoteIslandLevel, RemoteIslandPreset>> presets;
  final Map<RemoteIslandLevel, RemoteIslandPreset> defaults;

  RemoteIslandPreset? getPreset(String id, RemoteIslandLevel level) {
    if (level == RemoteIslandLevel.allParts) return null;
    final perCountry = presets[id];
    if (perCountry != null && perCountry[level] != null) {
      return perCountry[level];
    }
    return defaults[level];
  }

  RemoteIslandPresetStore mapKeys(String? Function(String) resolver) {
    if (presets.isEmpty) return this;
    final out = <String, Map<RemoteIslandLevel, RemoteIslandPreset>>{};
    for (final e in presets.entries) {
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
    return RemoteIslandPresetStore(presets: out, defaults: defaults);
  }
}

const kRemoteIslandPresets =
    <String, Map<RemoteIslandLevel, RemoteIslandPreset>>{
  'AU': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'BR': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'DE': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'DK': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.4874,
      maxClustersToKeep: 2,
      minClusterDensityRatio: 0.4979,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'ES': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.05,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.9528,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'GB': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'ID': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'IT': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'JP': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'MY': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'PT': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.8134,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.7799,
    ),
  },
  'US': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.05,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.75,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'X_FRA': {
    RemoteIslandLevel.allParts: RemoteIslandPreset(
      linkFactor: 0.6612,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.5566,
    ),
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.05,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.3208,
    ),
    RemoteIslandLevel.mainPlus: RemoteIslandPreset(
      linkFactor: 0.4956,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
  'X_NOR': {
    RemoteIslandLevel.main: RemoteIslandPreset(
      linkFactor: 0.05,
      maxClustersToKeep: 1,
      minClusterDensityRatio: 0.45,
    ),
  },
};

const kDefaultRemoteIslandPresetStore =
    RemoteIslandPresetStore(presets: kRemoteIslandPresets);
