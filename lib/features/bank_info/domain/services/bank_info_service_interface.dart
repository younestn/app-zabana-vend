import 'package:sixvalley_vendor_app/features/profile/domain/models/profile_body.dart';
import 'package:sixvalley_vendor_app/features/profile/domain/models/profile_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixvalley_vendor_app/data/model/response/response_model.dart';
import 'package:sixvalley_vendor_app/features/bank_info/domain/models/current_commission_invoice_model.dart';

abstract class BankInfoServiceInterface {
  Future<dynamic> getBankList();
  Future<dynamic> chartFilterData(String? type);
  Future<dynamic> updateBank(
      ProfileInfoModel userInfoModel, ProfileBody seller, String token);
  String getBankToken();
  Future<dynamic> getOrderFilterData(String? type);
  Future<dynamic> getCurrentMonthCommissionInvoice();
  Future<ResponseModel> sendCommissionReceipt(
      int invoiceId, String? note, XFile receiptImage);
}
