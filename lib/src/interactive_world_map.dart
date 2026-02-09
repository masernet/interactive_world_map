import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import 'fit/remote_island_presets.dart';
import 'generated/world_50m_robin.dart';
import 'geoscheme/map_id_resolver.dart';
import 'world_map_controller.dart';
import 'world_map_style.dart';

/// ---------- Internal data structures ----------

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
  // minimaler Abstand zwischen zwei Axis-aligned Rects (0 wenn sie sich schneiden)
  final dx = math.max(0.0, math.max(a.left - b.right, b.left - a.right));
  final dy = math.max(0.0, math.max(a.top - b.bottom, b.top - a.bottom));
  return math.sqrt(dx * dx + dy * dy);
}

const double _defaultMaxClusterSpanFactor = 3.0;
const double _defaultAreaWeight = 1.0;
const double _defaultPartCountWeight = 250.0;

class _CountryCache {
  final String id;
  final List<_CountryPart> parts;

  _CountryCache({required this.id, required this.parts});

  Rect get fullBounds {
    Rect r = parts.first.bounds;
    for (final p in parts.skip(1)) {
      r = r.expandToInclude(p.bounds);
    }
    return r;
  }

  /// Cluster-basierter Filter: "remote islands" werden nicht per DistanceFactor
  /// zur Mainland entfernt, sondern über Cluster-Auswahl.
  Rect filteredBounds({
    required double linkFactor,
    required int maxClustersToKeep,
    required double minClusterDensityRatio,
  }) {
    final kept = _selectClusters(
      linkFactor: linkFactor,
      maxClustersToKeep: maxClustersToKeep,
      minClusterDensityRatio: minClusterDensityRatio,
    );

    Rect r = kept.first.bounds;
    for (final c in kept.skip(1)) {
      r = r.expandToInclude(c.bounds);
    }
    return r;
  }

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

    // Score berechnen (USA/Alaska Problem: partCount hilft)
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

    // Bounds pro Root (initial: Part bounds)
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

      // WICHTIG: verhindert "Ketten-Union" bis Spitzbergen/Alaska
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

      // Union (rb -> ra)
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

        // Nach wie vor: lokale "Nähe"
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

/// ---------- Widget ----------

class InteractiveWorldMap extends StatefulWidget {
  const InteractiveWorldMap({
    super.key,
    this.controller,
    this.style = const WorldMapStyle(),
    this.allowPan = true,
    this.allowZoom = true,
    this.visibleCountryIds,
    this.excludeRemoteIslandsInRender = false,
    this.mapIdResolver = defaultMapIdResolver,
    this.onCountryTap,
    this.selectOnTap = false,
    this.toggleSelectionOnTap = false,
  });

  final WorldMapController? controller;
  final WorldMapStyle style;

  final bool allowPan;
  final bool allowZoom;

  final Set<String>? visibleCountryIds;
  final bool excludeRemoteIslandsInRender;
  final MapIdResolver mapIdResolver;

  final ValueChanged<String>? onCountryTap;
  final bool selectOnTap;
  final bool toggleSelectionOnTap;

  @override
  State<InteractiveWorldMap> createState() => _InteractiveWorldMapState();
}

class _InteractiveWorldMapState extends State<InteractiveWorldMap>
    with TickerProviderStateMixin {
  final _internalTransform = TransformationController();

  final _pathCache = <String, Path>{};
  List<_CountryCache>? _countries;

  Size _viewportSize = Size.zero;
  AnimationController? _fitAnim;

  Map<String, List<_CountryPart>>? _renderFilteredParts;
  String? _localSelectedId;

  TransformationController get _transform =>
      widget.controller?.transformationController ?? _internalTransform;

  String? get _selectedId =>
      widget.controller?.selectedId ?? _localSelectedId;

  Set<String> get _highlightedIds =>
      widget.controller?.highlightedIds ?? const <String>{};

  @override
  void initState() {
    super.initState();
    widget.controller?.attachFitHandler(_onFitRequest);
  }

  @override
  void didUpdateWidget(covariant InteractiveWorldMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.attachFitHandler(null);
      widget.controller?.attachFitHandler(_onFitRequest);
    }
    if (oldWidget.visibleCountryIds != widget.visibleCountryIds ||
        oldWidget.mapIdResolver != widget.mapIdResolver) {
      _countries = null;
      _renderFilteredParts = null;
    }
    if (oldWidget.excludeRemoteIslandsInRender &&
        !widget.excludeRemoteIslandsInRender &&
        _renderFilteredParts != null) {
      setState(() {
        _renderFilteredParts = null;
      });
    }
  }

  @override
  void dispose() {
    widget.controller?.attachFitHandler(null);
    _fitAnim?.dispose();
    _internalTransform.dispose();
    super.dispose();
  }

  /// ---------- SVG helpers ----------

  List<String> _splitSubpaths(String d) {
    return d
        .split(RegExp(r'(?=[Mm])'))
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }

  Path _parsePath(String d, bool evenOdd) {
    return _pathCache.putIfAbsent(d, () {
      final p = parseSvgPathData(d);
      if (evenOdd) p.fillType = PathFillType.evenOdd;
      return p;
    });
  }

  void _ensureCache() {
    if (_countries != null) return;

    final visible = _normalizeIds(widget.visibleCountryIds);
    final items = <_CountryCache>[];

    for (final e in WorldMapData.countries.entries) {
      if (visible != null && !visible.contains(e.key)) continue;

      final parts = <_CountryPart>[];
      for (final d in _splitSubpaths(e.value.d)) {
        final path = _parsePath(d, e.value.evenOdd);
        final bounds = path.getBounds();
        parts.add(_CountryPart(path, bounds));
      }

      if (parts.isEmpty) continue;

      items.add(_CountryCache(id: e.key, parts: parts));
    }

    _countries = items;
  }

  void _updateRenderFilter(Set<String> ids, FitOptions options) {
    if (!widget.excludeRemoteIslandsInRender) {
      if (_renderFilteredParts != null) {
        setState(() {
          _renderFilteredParts = null;
        });
      }
      return;
    }

    _ensureCache();
    final next = <String, List<_CountryPart>>{};
    var anyFiltered = false;
    for (final c in _countries!) {
      if (!ids.contains(c.id)) continue;
      final preset = options.presetForCountry(c.id);
      if (preset == null) continue;

      next[c.id] = c.filteredParts(
        linkFactor: preset.linkFactor,
        maxClustersToKeep: preset.maxClustersToKeep,
        minClusterDensityRatio: preset.minClusterDensityRatio,
      );
      anyFiltered = true;
    }

    setState(() {
      _renderFilteredParts = anyFiltered ? next : null;
    });
  }

  /// ---------- Fit logic ----------

  void _onFitRequest(Set<String> ids, FitOptions options) {
    final mappedIds = _normalizeIdsSet(ids);
    final mappedOptions = _normalizeFitOptions(options);
    _updateRenderFilter(mappedIds, mappedOptions);
    if (_viewportSize.isEmpty) return;
    _runFit(mappedIds, mappedOptions);
  }

  Rect? _unionBounds(Set<String> ids, FitOptions o) {
    _ensureCache();
    Rect? r;

    for (final c in _countries!) {
      if (!ids.contains(c.id)) continue;
      final preset = o.presetForCountry(c.id);
      final b = preset == null
          ? c.fullBounds
          : c.filteredBounds(
              linkFactor: preset.linkFactor,
              maxClustersToKeep: preset.maxClustersToKeep,
              minClusterDensityRatio: preset.minClusterDensityRatio,
            );

      r = (r == null) ? b : r.expandToInclude(b);
    }
    return r;
  }

  void _runFit(Set<String> ids, FitOptions o) {
    final rect = _unionBounds(ids, o);
    if (rect == null) return;

    final vw = _viewportSize.width;
    final vh = _viewportSize.height;
    final aw = math.max(0.0, vw - 2 * o.padding);
    final ah = math.max(0.0, vh - 2 * o.padding);

    final scale = math.min(aw / rect.width, ah / rect.height).clamp(0.8, 80.0);

    final center = Offset(vw / 2, vh / 2);
    final tx = center.dx - rect.center.dx * scale;
    final ty = center.dy - rect.center.dy * scale;

    final target = Matrix4.identity()
      ..translateByDouble(tx, ty, 0.0, 1.0)
      ..scaleByDouble(scale, scale, 1.0, 1.0);

    final tc = _transform;

    if (o.duration == null) {
      tc.value = target;
      return;
    }

    _fitAnim?.dispose();
    _fitAnim = AnimationController(vsync: this, duration: o.duration);
    final tween = Matrix4Tween(
      begin: tc.value,
      end: target,
    ).animate(CurvedAnimation(parent: _fitAnim!, curve: o.curve));

    _fitAnim!.addListener(() => tc.value = tween.value);
    _fitAnim!.forward();
  }

  Set<String>? _normalizeIds(Set<String>? ids) {
    if (ids == null) return null;
    return _normalizeIdsSet(ids);
  }

  Set<String> _normalizeIdsSet(Set<String> ids) {
    if (ids.isEmpty) return const <String>{};
    final out = <String>{};
    for (final id in ids) {
      final mapped = widget.mapIdResolver(id);
      if (mapped != null) out.add(mapped);
    }
    return out;
  }

  FitOptions _normalizeFitOptions(FitOptions options) {
    final mappedOverrides =
        _normalizePresetOverrides(options.presetOverrides);
    final mappedStore = options.presetStore.mapKeys(widget.mapIdResolver);
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
  ) {
    if (overrides.isEmpty) return overrides;
    final out = <String, Map<RemoteIslandLevel, RemoteIslandPreset>>{};
    for (final e in overrides.entries) {
      final key = widget.mapIdResolver(e.key) ?? e.key;
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

  String? _hitTestCountry(Offset scenePoint) {
    if (_countries == null) return null;
    for (final c in _countries!) {
      final parts = _renderFilteredParts?[c.id] ?? c.parts;
      for (final p in parts) {
        if (!p.bounds.contains(scenePoint)) continue;
        if (p.path.contains(scenePoint)) return c.id;
      }
    }
    return null;
  }

  void _handleTapUp(TapUpDetails details) {
    final scenePoint = _transform.toScene(details.localPosition);
    final hitId = _hitTestCountry(scenePoint);
    if (hitId == null) return;

    widget.onCountryTap?.call(hitId);

    if (!widget.selectOnTap) return;

    final current = _selectedId;
    final next =
        widget.toggleSelectionOnTap && current == hitId ? null : hitId;

    if (widget.controller != null) {
      widget.controller!.selectedId = next;
    } else {
      setState(() => _localSelectedId = next);
    }
  }

  /// ---------- Build ----------

  @override
  Widget build(BuildContext context) {
    _ensureCache();

    final vb = WorldMapData.viewBox;
    return LayoutBuilder(
      builder: (_, c) {
        _viewportSize = c.biggest;
        final repaint = widget.controller == null
            ? _transform
            : Listenable.merge([_transform, widget.controller!]);

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapUp: _handleTapUp,
          child: InteractiveViewer(
            transformationController: _transform,
            panEnabled: widget.allowPan,
            scaleEnabled: widget.allowZoom,
            constrained: false,
            minScale: 0.8,
            maxScale: 80,
            boundaryMargin: const EdgeInsets.all(2000),
            child: CustomPaint(
              size: Size(vb[2], vb[3]),
              painter: _WorldMapPainter(
                countries: _countries!,
                transform: _transform,
                repaint: repaint,
                style: widget.style,
                filteredPartsByCountry: _renderFilteredParts,
                controller: widget.controller,
                fallbackSelectedId: _selectedId,
                fallbackHighlightedIds: _highlightedIds,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ---------- Painter ----------

class _WorldMapPainter extends CustomPainter {
  _WorldMapPainter({
    required this.countries,
    required this.transform,
    required Listenable repaint,
    required this.style,
    required this.filteredPartsByCountry,
    required this.controller,
    required this.fallbackSelectedId,
    required this.fallbackHighlightedIds,
  }) : super(repaint: repaint);

  final List<_CountryCache> countries;
  final TransformationController transform;
  final WorldMapStyle style;
  final Map<String, List<_CountryPart>>? filteredPartsByCountry;
  final WorldMapController? controller;
  final String? fallbackSelectedId;
  final Set<String> fallbackHighlightedIds;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = transform.value.getMaxScaleOnAxis().clamp(0.0001, 1e9);
    final selectedId = controller?.selectedId ?? fallbackSelectedId;
    final highlightedIds =
        controller?.highlightedIds ?? fallbackHighlightedIds;

    final fill = Paint()..style = PaintingStyle.fill;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.strokeWidthForScale(scale)
      ..color = style.borderColor;

    for (final c in countries) {
      final parts = filteredPartsByCountry?[c.id] ?? c.parts;
      if (selectedId == c.id) {
        fill.color = style.selectedFillColor;
      } else if (highlightedIds.contains(c.id)) {
        fill.color = style.highlightedFillColor;
      } else {
        fill.color = style.landFillColor;
      }
      for (final p in parts) {
        canvas.drawPath(p.path, fill);
        if (style.showBorders) {
          canvas.drawPath(p.path, stroke);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WorldMapPainter oldDelegate) {
    return oldDelegate.style != style ||
        oldDelegate.countries != countries ||
        oldDelegate.filteredPartsByCountry != filteredPartsByCountry ||
        oldDelegate.controller != controller ||
        oldDelegate.fallbackSelectedId != fallbackSelectedId ||
        !setEquals(oldDelegate.fallbackHighlightedIds, fallbackHighlightedIds);
  }
}
