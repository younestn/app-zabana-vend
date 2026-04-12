import 'package:sixvalley_vendor_app/features/chat/domain/models/chat_model.dart';

class MessageModel {
  int? totalSize;
  int? limit;
  int? offset;
  List<Message>? message;

  MessageModel({this.totalSize, this.limit, this.offset, this.message});

  MessageModel.fromJson(Map<String, dynamic> json) {
    totalSize = int.tryParse('${json['total_size']}');
    limit = int.tryParse('${json['limit']}');
    offset = int.tryParse('${json['offset']}');
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }

}

class Message {
  int? id;
  int? userId;
  int? deliveryManId;
  int? adminId;
  String? message;
  bool? sentByCustomer;
  bool? sentByDeliveryMan;
  bool? sentBySeller;
  bool? sentByAdmin;
  bool? seenBySeller;
  bool? seenByAdmin;
  String? createdAt;
  String? updatedAt;
  Customer? customer;
  Customer? admin;
  DeliveryMan? deliveryMan;
  List<Attachment>? attachment;

  Message(
      {this.id,
        this.userId,
        this.deliveryManId,
        this.message,
        this.sentByCustomer,
        this.sentByDeliveryMan,
        this.sentBySeller,
        this.seenBySeller,
        this.createdAt,
        this.updatedAt,
        this.customer,
      this.deliveryMan,
        this.attachment
      });

  Message.fromJson(Map<String, dynamic> json) {
  id = json['id'];
userId = json['user_id'];

if (json['delivery_man_id'] != null) {
  deliveryManId = int.tryParse(json['delivery_man_id'].toString());
}

if (json['admin_id'] != null) {
  adminId = int.tryParse(json['admin_id'].toString());
}

message = json['message'];
sentByCustomer = json['sent_by_customer'] ?? false;
sentByDeliveryMan = json['sent_by_delivery_man'] ?? false;
sentBySeller = json['sent_by_seller'] ?? false;
sentByAdmin = json['sent_by_admin'] ?? false;
seenBySeller = json['seen_by_seller'];
seenByAdmin = json['seen_by_admin'];
createdAt = json['created_at'];
updatedAt = json['updated_at'];
customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
admin = json['admin'] != null ? Customer.fromJson(json['admin']) : null;
deliveryMan = json['delivery_man'] != null ? DeliveryMan.fromJson(json['delivery_man']) : null;
    if (json['attachment'] != null) {
      attachment = <Attachment>[];
      json['attachment'].forEach((v) {
        if(v['size'] != null){
          attachment!.add(Attachment.fromJson(v));
        }
      });
    }
  }
}


class Attachment {
  String? type;
  String? key;
  String? path;
  String? size;

  Attachment({this.type, this.key, this.path, this.size});

  Attachment.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    key = json['key'];
    path = json['path'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['key'] = key;
    data['path'] = path;
    data['size'] = size;
    return data;
  }
}