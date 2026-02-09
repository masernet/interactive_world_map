import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import 'fit/remote_island_presets.dart';
import 'generated/world_50m_robin.dart';
import 'geoscheme/map_id_resolver.dart';
import 'world_icon_style.dart';

@immutable
class IslandFilterOptions {
  const IslandFilterOptions({
    this.excludeRemoteIslands = false,
    this.remoteIslandLevel = RemoteIslandLevel.allParts,
    this.presetStore = kDefaultRemoteIslandPresetStore,
    this.presetOverrides = const {},
  });

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

  IslandFilterOptions copyWith({
    bool? excludeRemoteIslands,
    RemoteIslandLevel? remoteIslandLevel,
    RemoteIslandPresetStore? presetStore,
    Map<String, Map<RemoteIslandLevel, RemoteIslandPreset>>? presetOverrides,
  }) {
    return IslandFilterOptions(
      excludeRemoteIslands: excludeRemoteIslands ?? this.excludeRemoteIslands,
      remoteIslandLevel: remoteIslandLevel ?? this.remoteIslandLevel,
      presetStore: presetStore ?? this.presetStore,
      presetOverrides: presetOverrides ?? this.presetOverrides,
    );
  }
}

class WorldIcon extends StatelessWidget {
  const WorldIcon({
    super.key,
    required this.ids,
    this.size = 64,
    this.style = const WorldIconStyle(),
    this.fit = BoxFit.contain,
    this.padding = 0,
    this.islandOptions = const IslandFilterOptions(),
    this.mapIdResolver = defaultMapIdResolver,
  });

  final Set<String> ids;
  final double size;
  final WorldIconStyle style;
  final BoxFit fit;
  final double padding;
  final IslandFilterOptions islandOptions;
  final MapIdResolver mapIdResolver;

  @override
  Widget build(BuildContext context) {
    if (ids.isEmpty || size <= 0) {
      return SizedBox(width: size, height: size);
    }

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: WorldIconPainter(
          ids: ids,
          style: style,
          fit: fit,
          padding: padding,
          islandOptions: islandOptions,
          mapIdResolver: mapIdResolver,
        ),
      ),
    );
  }
}

class WorldIconPainter extends CustomPainter {
  WorldIconPainter({
    required this.ids,
    required this.style,
    required this.fit,
    required this.padding,
    required this.islandOptions,
    required this.mapIdResolver,
  });

  final Set<String> ids;
  final WorldIconStyle style;
  final BoxFit fit;
  final double padding;
  final IslandFilterOptions islandOptions;
  final MapIdResolver mapIdResolver;

  @override
  void paint(Canvas canvas, Size size) {
    if (ids.isEmpty) return;

    final parts =
        _WorldIconGeometry.collectParts(ids, islandOptions, mapIdResolver);
    if (parts.isEmpty) return;

    final bounds = _WorldIconGeometry.boundsFor(parts);
    if (bounds == null || bounds.width <= 0 || bounds.height <= 0) return;

    final targetW = math.max(0.0, size.width - 2 * padding);
    final targetH = math.max(0.0, size.height - 2 * padding);
    if (targetW <= 0 || targetH <= 0) return;

    final sx = targetW / bounds.width;
    final sy = targetH / bounds.height;
    if (sx <= 0 || sy <= 0) return;

    double scaleX;
    double scaleY;
    switch (fit) {
      case BoxFit.fill:
        scaleX = sx;
        scaleY = sy;
        break;
      case BoxFit.contain:
        final s = math.min(sx, sy);
        scaleX = s;
        scaleY = s;
        break;
      case BoxFit.cover:
        final s = math.max(sx, sy);
        scaleX = s;
        scaleY = s;
        break;
      case BoxFit.fitWidth:
        scaleX = sx;
        scaleY = sx;
        break;
      case BoxFit.fitHeight:
        scaleX = sy;
        scaleY = sy;
        break;
      case BoxFit.none:
        scaleX = 1.0;
        scaleY = 1.0;
        break;
      case BoxFit.scaleDown:
        final s = math.min(1.0, math.min(sx, sy));
        scaleX = s;
        scaleY = s;
        break;
    }

    final scaledW = bounds.width * scaleX;
    final scaledH = bounds.height * scaleY;

    final dx = padding + (targetW - scaledW) / 2 - bounds.left * scaleX;
    final dy = padding + (targetH - scaledH) / 2 - bounds.top * scaleY;

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.translate(dx, dy);
    canvas.scale(scaleX, scaleY);

    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = style.borderColor;

    if (!style.outlineOnly) {
      fill.color = style.fillColor;
    }

    if (style.showBorders && style.borderWidth > 0) {
      final invScale = 1 / math.max(scaleX, scaleY);
      stroke.strokeWidth = style.borderWidth * invScale;
    }

    for (final p in parts) {
      if (!style.outlineOnly) {
        canvas.drawPath(p.path, fill);
      }
      if (style.showBorders && style.borderWidth > 0) {
        canvas.drawPath(p.path, stroke);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant WorldIconPainter oldDelegate) {
    return oldDelegate.style != style ||
        oldDelegate.fit != fit ||
        oldDelegate.padding != padding ||
        oldDelegate.islandOptions != islandOptions ||
        oldDelegate.mapIdResolver != mapIdResolver ||
        !setEquals(oldDelegate.ids, ids);
  }
}

class _CountryPart {
  final Path path;
  final Rect bounds;
  final double area;

  _CountryPart(this.path, this.bounds) : area = bounds.width * bounds.height;
}

class _Cluster {
  final List<_CountryPart> parts;
  late final Rect bounds;
  late final double areaSum;
  late final int partCount;
  double score = 0;

  _Cluster(this.parts) {
    Rect r = parts.first.bounds;
    double a = 0;
    for (final p in parts) {
      r = r.expandToInclude(p.bounds);
      a += p.area;
    }
    bounds = r;
    areaSum = a;
    partCount = parts.length;
  }
}

double _diag(Rect r) {
  return math.sqrt(r.width * r.width + r.height * r.height);
}

double _rectArea(Rect r) {
  return r.width * r.height;
}

double _density(double areaSum, Rect bounds) {
  final a = _rectArea(bounds);
  if (a <= 0) return 0;
  final d = areaSum / a;
  return d > 1.0 ? 1.0 : d;
}

double _rectGap(Rect a, Rect b) {
  final dx = math.max(0.0, math.max(a.left - b.right, b.left - a.right));
  final dy = math.max(0.0, math.max(a.top - b.bottom, b.top - a.bottom));
  return math.sqrt(dx * dx + dy * dy);
}

const double _defaultMaxClusterSpanFactor = 3.0;
const double _defaultAreaWeight = 1.0;
const double _defaultPartCountWeight = 250.0;

class _CountryCache {
  _CountryCache({required this.id, required this.parts});

  final String id;
  final List<_CountryPart> parts;

  List<_CountryPart> filteredParts({
    required double linkFactor,
    required int maxClustersToKeep,
    required double minClusterDensityRatio,
  }) {
    final kept = _selectClusters(
      linkFactor: linkFactor,
      maxClustersToKeep: maxClustersToKeep,
      minClusterDensityRatio: minClusterDensityRatio,
    );

    final out = <_CountryPart>[];
    for (final c in kept) {
      out.addAll(c.parts);
    }
    return out;
  }

  List<_Cluster> _selectClusters({
    required double linkFactor,
    required int maxClustersToKeep,
    required double minClusterDensityRatio,
  }) {
    if (parts.length == 1) return [_Cluster(parts)];

    final clusters = _buildClusters(
      parts,
      linkFactor: linkFactor,
      minClusterDensityRatio: minClusterDensityRatio,
    );

    for (final c in clusters) {
      c.score =
          c.areaSum * _defaultAreaWeight + c.partCount * _defaultPartCountWeight;
    }

    clusters.sort((a, b) => b.score.compareTo(a.score));
    final keepN = math.max(1, maxClustersToKeep);

    final kept = <_Cluster>[];
    for (final c in clusters) {
      if (kept.length >= keepN) break;
      kept.add(c);
    }
    if (kept.isEmpty) kept.add(clusters.first);
    return kept;
  }

  static List<_Cluster> _buildClusters(
    List<_CountryPart> parts, {
    required double linkFactor,
    required double minClusterDensityRatio,
  }) {
    final n = parts.length;
    final parent = List<int>.generate(n, (i) => i);
    final rootBounds = List<Rect>.generate(n, (i) => parts[i].bounds);
    final rootAreaSum = List<double>.generate(n, (i) => parts[i].area);
    final partDiag = List<double>.generate(n, (i) => _diag(parts[i].bounds));
    double globalMaxPartDiag = 0;
    for (final d in partDiag) {
      if (d > globalMaxPartDiag) globalMaxPartDiag = d;
    }

    int find(int x) {
      while (parent[x] != x) {
        parent[x] = parent[parent[x]];
        x = parent[x];
      }
      return x;
    }

    bool tryUnion(int a, int b) {
      var ra = find(a);
      var rb = find(b);
      if (ra == rb) return false;

      final ba = rootBounds[ra];
      final bb = rootBounds[rb];
      final merged = ba.expandToInclude(bb);

      final mergedDiag = _diag(merged);
      final limitLocal =
          _defaultMaxClusterSpanFactor * math.max(_diag(ba), _diag(bb));
      final limitGlobal = _defaultMaxClusterSpanFactor * globalMaxPartDiag;
      final limit = math.min(limitLocal, limitGlobal);
      if (mergedDiag > limit) return false;

      if (minClusterDensityRatio > 0) {
        final areaA = rootAreaSum[ra];
        final areaB = rootAreaSum[rb];
        final areaMerged = areaA + areaB;

        final densityA = _density(areaA, ba);
        final densityB = _density(areaB, bb);
        final densityMerged = _density(areaMerged, merged);

        final densityLimit =
            math.max(densityA, densityB) * minClusterDensityRatio;
        if (densityMerged < densityLimit) return false;
      }

      parent[rb] = ra;
      rootBounds[ra] = merged;
      rootAreaSum[ra] = rootAreaSum[ra] + rootAreaSum[rb];
      return true;
    }

    for (int i = 0; i < n; i++) {
      final bi = parts[i].bounds;
      final di = _diag(bi);

      for (int j = i + 1; j < n; j++) {
        final bj = parts[j].bounds;
        final dj = _diag(bj);

        final eps = linkFactor * math.min(di, dj);
        final gap = _rectGap(bi, bj);

        if (gap <= eps) {
          tryUnion(i, j);
        }
      }
    }

    final groups = <int, List<_CountryPart>>{};
    for (int i = 0; i < n; i++) {
      final r = find(i);
      (groups[r] ??= <_CountryPart>[]).add(parts[i]);
    }

    return groups.values.map((p) => _Cluster(p)).toList();
  }
}

class _WorldIconGeometry {
  static final Map<String, _CountryCache> _countryCache = {};
  static final Map<String, Path> _pathCache = {};

  static List<String> _splitSubpaths(String d) {
    return d
        .split(RegExp(r'(?=[Mm])'))
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }

  static Path _parsePath(String d, bool evenOdd) {
    final key = '${evenOdd ? 1 : 0}::$d';
    return _pathCache.putIfAbsent(key, () {
      final p = parseSvgPathData(d);
      if (evenOdd) p.fillType = PathFillType.evenOdd;
      return p;
    });
  }

  static _CountryCache? _country(String id) {
    final cached = _countryCache[id];
    if (cached != null) return cached;

    final data = WorldMapData.countries[id];
    if (data == null) return null;

    final parts = <_CountryPart>[];
    for (final sd in _splitSubpaths(data.d)) {
      final p = _parsePath(sd, data.evenOdd);
      final b = p.getBounds();
      parts.add(_CountryPart(p, b));
    }

    if (parts.isEmpty) return null;
    final created = _CountryCache(id: id, parts: parts);
    _countryCache[id] = created;
    return created;
  }

  static List<_CountryPart> collectParts(
    Set<String> ids,
    IslandFilterOptions options,
    MapIdResolver mapIdResolver,
  ) {
    final normalizedIds = _normalizeIds(ids, mapIdResolver);
    final normalizedOptions = _normalizeOptions(options, mapIdResolver);
    final out = <_CountryPart>[];
    for (final id in normalizedIds) {
      final c = _country(id);
      if (c == null) continue;
      final preset = normalizedOptions.presetForCountry(id);
      final parts = preset == null
          ? c.parts
          : c.filteredParts(
              linkFactor: preset.linkFactor,
              maxClustersToKeep: preset.maxClustersToKeep,
              minClusterDensityRatio: preset.minClusterDensityRatio,
            );
      out.addAll(parts);
    }
    return out;
  }

  static Set<String> _normalizeIds(
    Set<String> ids,
    MapIdResolver resolver,
  ) {
    if (ids.isEmpty) return const <String>{};
    final out = <String>{};
    for (final id in ids) {
      final mapped = resolver(id);
      if (mapped != null) out.add(mapped);
    }
    return out;
  }

  static IslandFilterOptions _normalizeOptions(
    IslandFilterOptions options,
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

  static Map<String, Map<RemoteIslandLevel, RemoteIslandPreset>>
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

  static Rect? boundsFor(List<_CountryPart> parts) {
    if (parts.isEmpty) return null;
    Rect r = parts.first.bounds;
    for (final p in parts.skip(1)) {
      r = r.expandToInclude(p.bounds);
    }
    return r;
  }
}
