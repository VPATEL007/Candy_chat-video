import 'dart:convert';

/// Used by [mapJson] to map the [json] object to a dart object.
typedef JsonMapper<T> = T Function(Map<String, dynamic> json);

/// Maps the json string [data] to [T].
///
/// Returns a list of type [T] if the [data] is a json list, the object of type
/// [T] if the [data] is a json object or `null`.
dynamic mapJson<T>(String data, JsonMapper<T> mapper) {
  final json = jsonDecode(data);

  if (json is List) {
    final decodedObjects = <T>[];

    for (Map<String, dynamic> object in json) {
      decodedObjects.add(mapper(object));
    }

    return decodedObjects;
  } else if (json is Map) {
    return mapper(json);
  } else {
    return null;
  }
}

/// Iterates over every entry in the [json] map and calls `toJson()` if possible
/// on every entry recursively.
Map<String, dynamic> toPrimitiveJson(Map<String, dynamic> json) {
  return json.map((key, value) {
    dynamic jsonValue = _toJsonValue(value);

    if (jsonValue is Map) {
      jsonValue = toPrimitiveJson(jsonValue);
    } else if (jsonValue is List) {
      jsonValue = _listToPrimitiveJson(jsonValue);
    }

    return MapEntry<String, dynamic>(key, jsonValue);
  });
}

List<dynamic> _listToPrimitiveJson(List<dynamic> jsonList) {
  return jsonList.map((value) {
    final jsonValue = _toJsonValue(value);

    if (jsonValue is Map) {
      return toPrimitiveJson(jsonValue);
    } else if (jsonValue is List) {
      return _listToPrimitiveJson(jsonValue);
    } else {
      return jsonValue;
    }
  }).toList();
}

dynamic _toJsonValue(dynamic value) {
  try {
    return value.toJson();
  } on NoSuchMethodError {
    return value;
  }
}
 final Map<String, String> simpleCurrencySymbols = {
    'AFN': 'Af.',
    'TOP': r'T$',
    'MGA': 'Ar',
    'THB': '\u0e3f',
    'PAB': 'B/.',
    'ETB': 'Birr',
    'VEF': 'Bs',
    'BOB': 'Bs',
    'GHS': 'GHS',
    'CRC': '\u20a1',
    'NIO': r'C$',
    'GMD': 'GMD',
    'MKD': 'din',
    'BHD': 'din',
    'DZD': 'din',
    'IQD': 'din',
    'JOD': 'din',
    'KWD': 'din',
    'LYD': 'din',
    'RSD': 'din',
    'TND': 'din',
    'AED': 'dh',
    'MAD': 'dh',
    'STD': 'Db',
    'BSD': r'$',
    'FJD': r'$',
    'GYD': r'$',
    'KYD': r'$',
    'LRD': r'$',
    'SBD': r'$',
    'SRD': r'$',
    'AUD': r'$',
    'BBD': r'$',
    'BMD': r'$',
    'BND': r'$',
    'BZD': r'$',
    'CAD': r'$',
    'HKD': r'$',
    'JMD': r'$',
    'NAD': r'$',
    'NZD': r'$',
    'SGD': r'$',
    'TTD': r'$',
    'TWD': r'NT$',
    'USD': r'$',
    'XCD': r'$',
    'VND': '\u20ab',
    'AMD': 'Dram',
    'CVE': 'CVE',
    'EUR': '\u20ac',
    'AWG': 'Afl.',
    'HUF': 'Ft',
    'BIF': 'FBu',
    'CDF': 'FrCD',
    'CHF': 'CHF',
    'DJF': 'Fdj',
    'GNF': 'FG',
    'RWF': 'RF',
    'XOF': 'CFA',
    'XPF': 'FCFP',
    'KMF': 'CF',
    'XAF': 'FCFA',
    'HTG': 'HTG',
    'PYG': 'Gs',
    'UAH': '\u20b4',
    'PGK': 'PGK',
    'LAK': '\u20ad',
    'CZK': 'K\u010d',
    'SEK': 'kr',
    'ISK': 'kr',
    'DKK': 'kr',
    'NOK': 'kr',
    'HRK': 'kn',
    'MWK': 'MWK',
    'ZMK': 'ZWK',
    'AOA': 'Kz',
    'MMK': 'K',
    'GEL': 'GEL',
    'LVL': 'Ls',
    'ALL': 'Lek',
    'HNL': 'L',
    'SLL': 'SLL',
    'MDL': 'MDL',
    'RON': 'RON',
    'BGN': 'lev',
    'SZL': 'SZL',
    'TRY': 'TL',
    'LTL': 'Lt',
    'LSL': 'LSL',
    'AZN': 'man.',
    'BAM': 'KM',
    'MZN': 'MTn',
    'NGN': '\u20a6',
    'ERN': 'Nfk',
    'BTN': 'Nu.',
    'MRO': 'MRO',
    'MOP': 'MOP',
    'CUP': r'$',
    'CUC': r'$',
    'ARS': r'$',
    'CLF': 'UF',
    'CLP': r'$',
    'COP': r'$',
    'DOP': r'$',
    'MXN': r'$',
    'PHP': '\u20b1',
    'UYU': r'$',
    'FKP': '£',
    'GIP': '£',
    'SHP': '£',
    'EGP': 'E£',
    'LBP': 'L£',
    'SDG': 'SDG',
    'SSP': 'SSP',
    'GBP': '£',
    'SYP': '£',
    'BWP': 'P',
    'GTQ': 'Q',
    'ZAR': 'R',
    'BRL': r'R$',
    'OMR': 'Rial',
    'QAR': 'Rial',
    'YER': 'Rial',
    'IRR': 'Rial',
    'KHR': 'Riel',
    'MYR': 'RM',
    'SAR': 'Riyal',
    'BYR': 'BYR',
    'RUB': 'руб.',
    'MUR': 'Rs',
    'SCR': 'SCR',
    'LKR': 'Rs',
    'NPR': 'Rs',
    'INR': '\u20b9',
    'PKR': 'Rs',
    'IDR': 'Rp',
    'ILS': '\u20aa',
    'KES': 'Ksh',
    'SOS': 'SOS',
    'TZS': 'TSh',
    'UGX': 'UGX',
    'PEN': 'S/.',
    'KGS': 'KGS',
    'UZS': 'so\u02bcm',
    'TJS': 'Som',
    'BDT': '\u09f3',
    'WST': 'WST',
    'KZT': '\u20b8',
    'MNT': '\u20ae',
    'VUV': 'VUV',
    'KPW': '\u20a9',
    'KRW': '\u20a9',
    'JPY': '¥',
    'CNY': '¥',
    'PLN': 'z\u0142',
    'MVR': 'Rf',
    'NLG': 'NAf',
    'ZMW': 'ZK',
    'ANG': 'ƒ',
    'TMT': 'TMT',
  };