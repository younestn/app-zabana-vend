class NoestSettingsModel {
  String? name;
  String? displayName;
  int? vendorId;
  String? noestGuid;
  String? apiToken;
  int? status;
  String? connectedSince;
  int? isConnected;
  List<NoestDeliveryMethodModel>? deliveryMethods;

  NoestSettingsModel({
    this.name,
    this.displayName,
    this.vendorId,
    this.noestGuid,
    this.apiToken,
    this.status,
    this.connectedSince,
    this.isConnected,
    this.deliveryMethods,
  });

  NoestSettingsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    displayName = json['display_name'];
    vendorId = _parseInt(json['vendor_id']);
    noestGuid = json['noest_guid'];
    apiToken = json['api_token'];
    status = _parseInt(json['status']);
    connectedSince = json['connected_since'];
    isConnected = _parseInt(json['is_connected']);

    if (json['delivery_methods'] != null) {
      deliveryMethods = <NoestDeliveryMethodModel>[];
      json['delivery_methods'].forEach((v) {
        deliveryMethods!.add(NoestDeliveryMethodModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['display_name'] = displayName;
    data['vendor_id'] = vendorId;
    data['noest_guid'] = noestGuid;
    data['api_token'] = apiToken;
    data['status'] = status;
    data['connected_since'] = connectedSince;
    data['is_connected'] = isConnected;
    if (deliveryMethods != null) {
      data['delivery_methods'] = deliveryMethods!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static int _parseInt(dynamic value) {
    if (value is bool) {
      return value ? 1 : 0;
    }
    return int.tryParse(value.toString()) ?? 0;
  }
}

class NoestDeliveryMethodModel {
  String? id;
  String? title;
  String? name;
  int? status;

  NoestDeliveryMethodModel({
    this.id,
    this.title,
    this.name,
    this.status,
  });

  NoestDeliveryMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title'];
    name = json['name'];
    status = NoestSettingsModel._parseInt(json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['name'] = name;
    data['status'] = status;
    return data;
  }
}