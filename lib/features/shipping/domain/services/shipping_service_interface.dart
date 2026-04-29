import 'package:sixvalley_vendor_app/features/shipping/domain/models/shipping_model.dart';
import 'package:sixvalley_vendor_app/features/shipping/domain/models/noest_settings_model.dart';

abstract class ShippingServiceInterface {
  Future<dynamic> getShipping();
  Future<dynamic> getShippingMethod(String token);
  Future<dynamic> addShipping(ShippingModel? shipping);
  Future<dynamic> updateShipping(
      String? title, String? duration, double? cost, int? id);
  Future<dynamic> deleteShipping(int? id);
  Future<dynamic> getCategoryWiseShippingMethod();
  Future<dynamic> getSelectedShippingMethodType();
  Future<dynamic> setShippingMethodType(String? type);
  Future<dynamic> setCategoryWiseShippingCost(
      List<int?> ids, List<double> cost, List<int> multiPly);
  Future<dynamic> shippingOnOff(int? id, int status);

  Future<dynamic> getNoestSettings(String token);
  Future<dynamic> saveNoestSettings(
      String token, String? noestGuid, String? apiToken, int status);
  Future<dynamic> testNoestConnection(
      String token, String? noestGuid, String? apiToken);
}
