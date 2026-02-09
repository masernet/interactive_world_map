import 'un_geoscheme.dart';
import 'map_id_resolver.dart';

class GeoschemeToMap {
  const GeoschemeToMap._();

  static Set<String> mapIdsForCountries(
    Iterable<String> alpha2Countries, {
    MapIdResolver mapIdResolver = defaultMapIdResolver,
  }) {
    final out = <String>{};
    for (final a2 in alpha2Countries) {
      final id = mapIdResolver(a2);
      if (id != null) out.add(id);
    }
    return out;
  }

  static Set<String> mapIdsForSubregion(
    String subregion, {
    MapIdResolver mapIdResolver = defaultMapIdResolver,
  }) {
    final a2 = UnGeoscheme.countriesInSubregion(subregion);
    return mapIdsForCountries(a2, mapIdResolver: mapIdResolver);
  }

  static Set<String> mapIdsForRegion(
    String region, {
    MapIdResolver mapIdResolver = defaultMapIdResolver,
  }) {
    final a2 = UnGeoscheme.countriesInRegion(region);
    return mapIdsForCountries(a2, mapIdResolver: mapIdResolver);
  }

  static Set<String> mapIdsForIntermediateRegion(
    String intermediateRegion, {
    MapIdResolver mapIdResolver = defaultMapIdResolver,
  }) {
    final a2 = UnGeoscheme.countriesInIntermediateRegion(intermediateRegion);
    return mapIdsForCountries(a2, mapIdResolver: mapIdResolver);
  }
}
