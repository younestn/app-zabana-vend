import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/auth/controllers/auth_controller.dart';
import 'package:sixvalley_vendor_app/features/auth/screens/login_screen.dart';
import 'package:sixvalley_vendor_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:sixvalley_vendor_app/features/maintenance/maintenance_screen.dart';
import 'package:sixvalley_vendor_app/features/product/screens/product_list_screen.dart';
import 'package:sixvalley_vendor_app/features/refund/domain/models/refund_model.dart';
import 'package:sixvalley_vendor_app/features/refund/screens/refund_details_screen.dart';
import 'package:sixvalley_vendor_app/features/splash/controllers/splash_controller.dart';
import 'package:sixvalley_vendor_app/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_vendor_app/features/wallet/screens/wallet_screen.dart';
import 'package:sixvalley_vendor_app/notification/models/notification_body.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/features/chat/screens/inbox_screen.dart';
import 'package:sixvalley_vendor_app/features/chat/screens/chat_screen.dart';
import 'package:sixvalley_vendor_app/features/chat/controllers/chat_controller.dart';
import 'package:sixvalley_vendor_app/features/notification/screens/notification_screen.dart';
import 'package:sixvalley_vendor_app/features/order_details/screens/order_details_screen.dart';

import '../main.dart';

class MyNotification {

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for order and chat notifications.',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification'),
  );

  static String? _getTitle(RemoteMessage message) {
    return message.notification?.title ?? message.data['title']?.toString();
  }

  static String? _getBody(RemoteMessage message) {
    return message.notification?.body ?? message.data['body']?.toString();
  }

  static NotificationBody? _getPayload(RemoteMessage message) {
    if (message.data.isEmpty) {
      return null;
    }
    return NotificationBody.fromJson(message.data);
  }

  static Future<void> _handleNotificationRouting(
    NotificationBody? payload, {
    String? title,
  }) async {
  if (payload?.type == 'chatting' || (title?.contains('chatting') ?? false)) {
  final int chatIndex = _resolveChatIndex(payload);

  Provider.of<ChatController>(Get.context!, listen: false)
      .setUserTypeIndex(Get.context!, chatIndex, isUpdate: false);

  if ((payload?.chatType?.toLowerCase() ?? '') == 'admin') {
    Get.navigator!.push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userId: payload?.chatTargetId ?? 0,
          name: 'Admin',
        ),
      ),
    );
  } else {
    Get.navigator!.push(
      MaterialPageRoute(
        builder: (context) => InboxScreen(
          fromNotification: true,
          initIndex: chatIndex,
        ),
      ),
    );
  }
} else if (payload?.type == 'Theme' || (title?.contains('Theme') ?? false)) {
      Get.navigator!.push(
        MaterialPageRoute(builder: (context) => const NotificationScreen()),
      );
    } else if (payload?.orderId != null && payload?.type != 'refund') {
      Get.navigator!.push(
        MaterialPageRoute(
          builder: (context) => OrderDetailsScreen(
            orderId: payload!.orderId,
            fromNotification: true,
          ),
        ),
      );
    } else if (payload?.type == 'wallet_withdraw') {
      Get.navigator!.push(
        MaterialPageRoute(builder: (context) => const WalletScreen(fromNotification: true)),
      );
    } else if (payload?.type == 'product_request_approved_message') {
      Get.navigator!.push(
        MaterialPageRoute(builder: (context) => const ProductListMenuScreen(fromNotification: true)),
      );
    } else if (payload?.type == 'refund') {
      Get.navigator!.push(
        MaterialPageRoute(
          builder: (context) => RefundDetailsScreen(
            fromNotification: true,
            refundModel: RefundModel(id: payload?.refundId),
            orderDetailsId: payload?.orderDetailsId,
          ),
        ),
      );
    }
  }

  static Future<void> _initializeLocalNotifications(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, {
    bool withTapHandler = true,
  }) async {
    const androidInitialize = AndroidInitializationSettings('notification_icon');
    const iOSInitialize = DarwinInitializationSettings();
    const initializationsSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iOSInitialize,
    );

    if (withTapHandler) {
      await flutterLocalNotificationsPlugin.initialize(
        initializationsSettings,
        onDidReceiveNotificationResponse: (NotificationResponse data) async {
          try {
            NotificationBody? payload;
            if (data.payload != null && data.payload!.isNotEmpty) {
              payload = NotificationBody.fromJson(jsonDecode(data.payload!));
            }
            await _handleNotificationRouting(payload);
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
          }
        },
      );
    } else {
      await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
    }

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }
  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  await _initializeLocalNotifications(flutterLocalNotificationsPlugin);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  if (kDebugMode) {
    debugPrint(
      "onMessage: ${message.notification?.title}/${message.notification?.body}/${message.data}",
    );
  }

  if (message.data['type'] == 'maintenance_mode') {
    final SplashController splashProvider =
        Provider.of<SplashController>(Get.context!, listen: false);
    await splashProvider.initConfig();

    ConfigModel? config =
        Provider.of<SplashController>(Get.context!, listen: false).configModel;

    bool isMaintenanceRoute =
        Provider.of<SplashController>(Get.context!, listen: false)
            .isMaintenanceModeScreen();

    if (config?.maintenanceModeData?.maintenanceStatus == 1 &&
        (config?.maintenanceModeData?.selectedMaintenanceSystem?.vendorApp == 1)) {
      Navigator.of(Get.context!).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MaintenanceScreen(),
          settings: const RouteSettings(name: 'MaintenanceScreen'),
        ),
      );
    } else if (config?.maintenanceModeData?.maintenanceStatus == 0 &&
        isMaintenanceRoute) {
      final AuthController authController =
          Provider.of<AuthController>(Get.context!, listen: false);
      if (authController.isLoggedIn()) {
        Navigator.of(Get.context!).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        Navigator.of(Get.context!).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
    return;
  }

  await showNotification(message, flutterLocalNotificationsPlugin, false);
});


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
  if (kDebugMode) {
    debugPrint(
      "onOpenApp: ${message.notification?.title}/${message.toMap()}/${message.notification?.titleLocKey}",
    );
  }

  final NotificationBody? payload = _getPayload(message);
  final String? title = _getTitle(message);

  await _handleNotificationRouting(payload, title: title);

  if (message.data['type'] == 'maintenance_mode') {
    final SplashController splashProvider =
        Provider.of<SplashController>(Get.context!, listen: false);
    await splashProvider.initConfig();

    ConfigModel? config =
        Provider.of<SplashController>(Get.context!, listen: false).configModel;

    bool isMaintenanceRoute =
        Provider.of<SplashController>(Get.context!, listen: false)
            .isMaintenanceModeScreen();

    if (config?.maintenanceModeData?.maintenanceStatus == 1 &&
        (config?.maintenanceModeData?.selectedMaintenanceSystem?.vendorApp == 1)) {
      Navigator.of(Get.context!).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MaintenanceScreen(),
          settings: const RouteSettings(name: 'MaintenanceScreen'),
        ),
      );
    } else if (config?.maintenanceModeData?.maintenanceStatus == 0 &&
        isMaintenanceRoute) {
      final AuthController authController =
          Provider.of<AuthController>(Get.context!, listen: false);
      if (authController.isLoggedIn()) {
        Navigator.of(Get.context!).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        Navigator.of(Get.context!).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }
});
  }

static Future<void> showNotification(
  RemoteMessage message,
  FlutterLocalNotificationsPlugin fln,
  bool data,
) async {
  String? title = _getTitle(message);
  String? body = _getBody(message);

  if ((title == null || title.isEmpty) &&
      (body == null || body.isEmpty)) {
    return;
  }

  String? image =
      (message.data['image'] != null &&
              message.data['image'].toString().isNotEmpty)
          ? (message.data['image'].toString().startsWith('http')
              ? message.data['image'].toString()
              : '${AppConstants.baseUrl}/storage/app/public/notification/${message.data['image']}')
          : null;

  if (image != null && image.isNotEmpty) {
    try {
      await showBigPictureNotificationHiddenLargeIcon(
        title,
        body,
        message.data,
        image,
        fln,
      );
    } catch (e) {
      await showBigTextNotification(title, body ?? '', message.data, fln);
    }
  } else {
    await showBigTextNotification(title, body ?? '', message.data, fln);
  }
}


  static Future<void> showBigTextNotification(String? title, String body, Map<String, dynamic> data, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
  _channel.id,
  _channel.name,
  channelDescription: _channel.description,
  importance: Importance.max,
  styleInformation: bigTextStyleInformation,
  priority: Priority.max,
  playSound: true,
  sound: const RawResourceAndroidNotificationSound('notification'),
);
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(data));
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(String? title, String? body, Map<String, dynamic> data, String image, FlutterLocalNotificationsPlugin fln) async {
    final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: title, htmlFormatContentTitle: true,
      summaryText: body, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
  _channel.id,
  _channel.name,
  channelDescription: _channel.description,
  largeIcon: FilePathAndroidBitmap(largeIconPath),
  priority: Priority.max,
  playSound: true,
  styleInformation: bigPictureStyleInformation,
  importance: Importance.max,
  sound: const RawResourceAndroidNotificationSound('notification'),
);
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics, payload: jsonEncode(data));
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final Response response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final File file = File(filePath);
    await file.writeAsBytes(response.data);
    return filePath;
  }

  static int _resolveChatIndex(NotificationBody? payload) {
  final type = payload?.chatType?.toLowerCase();

  if (type == 'admin') return 2;
  if (type == 'delivery-man' || type == 'delivery_man') return 1;
  return 0;
}

}

@pragma('vm:entry-point')
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await MyNotification._initializeLocalNotifications(
    flutterLocalNotificationsPlugin,
    withTapHandler: false,
  );

  if (kDebugMode) {
    debugPrint(
      "onBackground: ${message.notification?.title}/${message.notification?.body}/${message.data}",
    );
  }

  if (message.data['type'] != 'maintenance_mode') {
    await MyNotification.showNotification(
      message,
      flutterLocalNotificationsPlugin,
      true,
    );
  }
}