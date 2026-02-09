import 'package:flutter/foundation.dart';

@immutable
class CountryGeo {
  const CountryGeo({required this.region, required this.subregion, this.intermediateRegion});

  final String region;
  final String subregion;
  final String? intermediateRegion;
}

const Map<String, CountryGeo> unGeoschemeByAlpha2 = <String, CountryGeo>{
  'AD': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'AE': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'AF': CountryGeo(region: 'Asia', subregion: 'Southern Asia'),
  'AG': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'AI': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'AL': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'AM': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'AO': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Middle Africa'),
  'AQ': CountryGeo(region: '', subregion: ''),
  'AR': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'AS': CountryGeo(region: 'Oceania', subregion: 'Polynesia'),
  'AT': CountryGeo(region: 'Europe', subregion: 'Western Europe'),
  'AU': CountryGeo(region: 'Oceania', subregion: 'Australia and New Zealand'),
  'AW': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'AX': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'AZ': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'BA': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'BB': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'BD': CountryGeo(region: 'Asia', subregion: 'Southern Asia'),
  'BE': CountryGeo(region: 'Europe', subregion: 'Western Europe'),
  'BF': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'BG': CountryGeo(region: 'Europe', subregion: 'Eastern Europe'),
  'BH': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'BI': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'BJ': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'BL': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'BM': CountryGeo(region: 'Americas', subregion: 'Northern America'),
  'BN': CountryGeo(region: 'Asia', subregion: 'South-eastern Asia'),
  'BO': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'BQ': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'BR': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'BS': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'BT': CountryGeo(region: 'Asia', subregion: 'Southern Asia'),
  'BV': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'BW': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Southern Africa'),
  'BY': CountryGeo(region: 'Europe', subregion: 'Eastern Europe'),
  'BZ': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Central America'),
  'CA': CountryGeo(region: 'Americas', subregion: 'Northern America'),
  'CC': CountryGeo(region: 'Oceania', subregion: 'Australia and New Zealand'),
  'CD': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Middle Africa'),
  'CF': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Middle Africa'),
  'CG': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Middle Africa'),
  'CH': CountryGeo(region: 'Europe', subregion: 'Western Europe'),
  'CI': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'CK': CountryGeo(region: 'Oceania', subregion: 'Polynesia'),
  'CL': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'CM': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Middle Africa'),
  'CN': CountryGeo(region: 'Asia', subregion: 'Eastern Asia'),
  'CO': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'CR': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Central America'),
  'CU': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'CV': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'CW': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'CX': CountryGeo(region: 'Oceania', subregion: 'Australia and New Zealand'),
  'CY': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'CZ': CountryGeo(region: 'Europe', subregion: 'Eastern Europe'),
  'DE': CountryGeo(region: 'Europe', subregion: 'Western Europe'),
  'DJ': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'DK': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'DM': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'DO': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'DZ': CountryGeo(region: 'Africa', subregion: 'Northern Africa'),
  'EC': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'EE': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'EG': CountryGeo(region: 'Africa', subregion: 'Northern Africa'),
  'EH': CountryGeo(region: 'Africa', subregion: 'Northern Africa'),
  'ER': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'ES': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'ET': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'FI': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'FJ': CountryGeo(region: 'Oceania', subregion: 'Melanesia'),
  'FK': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'FM': CountryGeo(region: 'Oceania', subregion: 'Micronesia'),
  'FO': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'FR': CountryGeo(region: 'Europe', subregion: 'Western Europe'),
  'GA': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Middle Africa'),
  'GB': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'GD': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'GE': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'GF': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'GG': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'GH': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'GI': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'GL': CountryGeo(region: 'Americas', subregion: 'Northern America'),
  'GM': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'GN': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'GP': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'GQ': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Middle Africa'),
  'GR': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'GS': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'GT': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Central America'),
  'GU': CountryGeo(region: 'Oceania', subregion: 'Micronesia'),
  'GW': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'GY': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'HK': CountryGeo(region: 'Asia', subregion: 'Eastern Asia'),
  'HM': CountryGeo(region: 'Oceania', subregion: 'Australia and New Zealand'),
  'HN': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Central America'),
  'HR': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'HT': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'HU': CountryGeo(region: 'Europe', subregion: 'Eastern Europe'),
  'ID': CountryGeo(region: 'Asia', subregion: 'South-eastern Asia'),
  'IE': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'IL': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'IM': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'IN': CountryGeo(region: 'Asia', subregion: 'Southern Asia'),
  'IO': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'IQ': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'IR': CountryGeo(region: 'Asia', subregion: 'Southern Asia'),
  'IS': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'IT': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'JE': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'JM': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'JO': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'JP': CountryGeo(region: 'Asia', subregion: 'Eastern Asia'),
  'KE': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'KG': CountryGeo(region: 'Asia', subregion: 'Central Asia'),
  'KH': CountryGeo(region: 'Asia', subregion: 'South-eastern Asia'),
  'KI': CountryGeo(region: 'Oceania', subregion: 'Micronesia'),
  'KM': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'KN': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'KP': CountryGeo(region: 'Asia', subregion: 'Eastern Asia'),
  'KR': CountryGeo(region: 'Asia', subregion: 'Eastern Asia'),
  'KW': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'KY': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'KZ': CountryGeo(region: 'Asia', subregion: 'Central Asia'),
  'LA': CountryGeo(region: 'Asia', subregion: 'South-eastern Asia'),
  'LB': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'LC': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'LI': CountryGeo(region: 'Europe', subregion: 'Western Europe'),
  'LK': CountryGeo(region: 'Asia', subregion: 'Southern Asia'),
  'LR': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'LS': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Southern Africa'),
  'LT': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'LU': CountryGeo(region: 'Europe', subregion: 'Western Europe'),
  'LV': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'LY': CountryGeo(region: 'Africa', subregion: 'Northern Africa'),
  'MA': CountryGeo(region: 'Africa', subregion: 'Northern Africa'),
  'MC': CountryGeo(region: 'Europe', subregion: 'Western Europe'),
  'MD': CountryGeo(region: 'Europe', subregion: 'Eastern Europe'),
  'ME': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'MF': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'MG': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'MH': CountryGeo(region: 'Oceania', subregion: 'Micronesia'),
  'MK': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'ML': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'MM': CountryGeo(region: 'Asia', subregion: 'South-eastern Asia'),
  'MN': CountryGeo(region: 'Asia', subregion: 'Eastern Asia'),
  'MO': CountryGeo(region: 'Asia', subregion: 'Eastern Asia'),
  'MP': CountryGeo(region: 'Oceania', subregion: 'Micronesia'),
  'MQ': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'MR': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'MS': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'MT': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'MU': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'MV': CountryGeo(region: 'Asia', subregion: 'Southern Asia'),
  'MW': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'MX': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Central America'),
  'MY': CountryGeo(region: 'Asia', subregion: 'South-eastern Asia'),
  'MZ': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'NA': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Southern Africa'),
  'NC': CountryGeo(region: 'Oceania', subregion: 'Melanesia'),
  'NE': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'NF': CountryGeo(region: 'Oceania', subregion: 'Australia and New Zealand'),
  'NG': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'NI': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Central America'),
  'NL': CountryGeo(region: 'Europe', subregion: 'Western Europe'),
  'NO': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'NP': CountryGeo(region: 'Asia', subregion: 'Southern Asia'),
  'NR': CountryGeo(region: 'Oceania', subregion: 'Micronesia'),
  'NU': CountryGeo(region: 'Oceania', subregion: 'Polynesia'),
  'NZ': CountryGeo(region: 'Oceania', subregion: 'Australia and New Zealand'),
  'OM': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'PA': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Central America'),
  'PE': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'PF': CountryGeo(region: 'Oceania', subregion: 'Polynesia'),
  'PG': CountryGeo(region: 'Oceania', subregion: 'Melanesia'),
  'PH': CountryGeo(region: 'Asia', subregion: 'South-eastern Asia'),
  'PK': CountryGeo(region: 'Asia', subregion: 'Southern Asia'),
  'PL': CountryGeo(region: 'Europe', subregion: 'Eastern Europe'),
  'PM': CountryGeo(region: 'Americas', subregion: 'Northern America'),
  'PN': CountryGeo(region: 'Oceania', subregion: 'Polynesia'),
  'PR': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'PS': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'PT': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'PW': CountryGeo(region: 'Oceania', subregion: 'Micronesia'),
  'PY': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'QA': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'RE': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'RO': CountryGeo(region: 'Europe', subregion: 'Eastern Europe'),
  'RS': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'RU': CountryGeo(region: 'Europe', subregion: 'Eastern Europe'),
  'RW': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'SA': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'SB': CountryGeo(region: 'Oceania', subregion: 'Melanesia'),
  'SC': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'SD': CountryGeo(region: 'Africa', subregion: 'Northern Africa'),
  'SE': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'SG': CountryGeo(region: 'Asia', subregion: 'South-eastern Asia'),
  'SH': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'SI': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'SJ': CountryGeo(region: 'Europe', subregion: 'Northern Europe'),
  'SK': CountryGeo(region: 'Europe', subregion: 'Eastern Europe'),
  'SL': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'SM': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'SN': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'SO': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'SR': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'SS': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'ST': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Middle Africa'),
  'SV': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Central America'),
  'SX': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'SY': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'SZ': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Southern Africa'),
  'TC': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'TD': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Middle Africa'),
  'TF': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'TG': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Western Africa'),
  'TH': CountryGeo(region: 'Asia', subregion: 'South-eastern Asia'),
  'TJ': CountryGeo(region: 'Asia', subregion: 'Central Asia'),
  'TK': CountryGeo(region: 'Oceania', subregion: 'Polynesia'),
  'TL': CountryGeo(region: 'Asia', subregion: 'South-eastern Asia'),
  'TM': CountryGeo(region: 'Asia', subregion: 'Central Asia'),
  'TN': CountryGeo(region: 'Africa', subregion: 'Northern Africa'),
  'TO': CountryGeo(region: 'Oceania', subregion: 'Polynesia'),
  'TR': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'TT': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'TV': CountryGeo(region: 'Oceania', subregion: 'Polynesia'),
  'TW': CountryGeo(region: '', subregion: ''),
  'TZ': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'UA': CountryGeo(region: 'Europe', subregion: 'Eastern Europe'),
  'UG': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'UM': CountryGeo(region: 'Oceania', subregion: 'Micronesia'),
  'US': CountryGeo(region: 'Americas', subregion: 'Northern America'),
  'UY': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'UZ': CountryGeo(region: 'Asia', subregion: 'Central Asia'),
  'VA': CountryGeo(region: 'Europe', subregion: 'Southern Europe'),
  'VC': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'VE': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'South America'),
  'VG': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'VI': CountryGeo(region: 'Americas', subregion: 'Latin America and the Caribbean', intermediateRegion: 'Caribbean'),
  'VN': CountryGeo(region: 'Asia', subregion: 'South-eastern Asia'),
  'VU': CountryGeo(region: 'Oceania', subregion: 'Melanesia'),
  'WF': CountryGeo(region: 'Oceania', subregion: 'Polynesia'),
  'WS': CountryGeo(region: 'Oceania', subregion: 'Polynesia'),
  'YE': CountryGeo(region: 'Asia', subregion: 'Western Asia'),
  'YT': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'ZA': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Southern Africa'),
  'ZM': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
  'ZW': CountryGeo(region: 'Africa', subregion: 'Sub-Saharan Africa', intermediateRegion: 'Eastern Africa'),
};

class UnGeoscheme {
  const UnGeoscheme._();

  static Set<String> countriesInRegion(String region) {
    final out = <String>{};
    for (final e in unGeoschemeByAlpha2.entries) {
      if (e.value.region == region) out.add(e.key);
    }
    return out;
  }

  static Set<String> countriesInSubregion(String subregion) {
    final out = <String>{};
    for (final e in unGeoschemeByAlpha2.entries) {
      if (e.value.subregion == subregion) out.add(e.key);
    }
    return out;
  }

  static Set<String> countriesInIntermediateRegion(String intermediateRegion) {
    final out = <String>{};
    for (final e in unGeoschemeByAlpha2.entries) {
      if (e.value.intermediateRegion == intermediateRegion) out.add(e.key);
    }
    return out;
  }

  static Set<String> countries({
    String? region,
    String? subregion,
    String? intermediateRegion,
  }) {
    final out = <String>{};
    for (final e in unGeoschemeByAlpha2.entries) {
      final g = e.value;
      if (region != null && g.region != region) continue;
      if (subregion != null && g.subregion != subregion) continue;
      if (intermediateRegion != null && g.intermediateRegion != intermediateRegion) continue;
      out.add(e.key);
    }
    return out;
  }

  /// Listen der möglichen Werte (für Dropdowns)
  static List<String> regions() {
    final s = <String>{};
    for (final g in unGeoschemeByAlpha2.values) {
      s.add(g.region);
    }
    final out = s.toList()..sort();
    return out;
  }

  static List<String> subregions({String? region}) {
    final s = <String>{};
    for (final e in unGeoschemeByAlpha2.entries) {
      final g = e.value;
      if (region != null && g.region != region) continue;
      s.add(g.subregion);
    }
    final out = s.toList()..sort();
    return out;
  }

  static List<String> intermediateRegions({String? subregion}) {
    final s = <String>{};
    for (final e in unGeoschemeByAlpha2.entries) {
      final g = e.value;
      if (subregion != null && g.subregion != subregion) continue;
      final ir = g.intermediateRegion;
      if (ir != null && ir.isNotEmpty) s.add(ir);
    }
    final out = s.toList()..sort();
    return out;
  }
}