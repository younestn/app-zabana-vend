class SellerBadgeModel {
  String? key;
  String? name;
  String? icon;
  String? color;
  int? level;
  double? complianceScore;
  bool? isManual;

  SellerBadgeModel({
    this.key,
    this.name,
    this.icon,
    this.color,
    this.level,
    this.complianceScore,
    this.isManual,
  });

  SellerBadgeModel.fromJson(Map<String, dynamic> json) {
    key = _stringValue(json['key']);
    name = _stringValue(json['name']) ?? _stringValue(json['key']);
    icon = _stringValue(json['icon']);
    color = _stringValue(json['color']);
    level = _intValue(json['level']);
    complianceScore = _doubleValue(json['compliance_score']);
    isManual = _boolValue(json['is_manual']);
  }

  static SellerBadgeModel? fromNullableJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return SellerBadgeModel.fromJson(json);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': key,
      'name': name,
      'icon': icon,
      'color': color,
      'level': level,
      'compliance_score': complianceScore,
      'is_manual': isManual,
    };
  }

  static String? _stringValue(dynamic value) {
    final String raw = value?.toString().trim() ?? '';
    return raw.isEmpty || raw.toLowerCase() == 'null' ? null : raw;
  }

  static int? _intValue(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }

  static double? _doubleValue(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }

  static bool? _boolValue(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }

    final String raw = value.toString().trim().toLowerCase();
    if (raw == '1' || raw == 'true') {
      return true;
    }
    if (raw == '0' || raw == 'false') {
      return false;
    }

    return null;
  }
}
