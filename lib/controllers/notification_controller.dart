import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:umoja_agri/services/notification_service.dart';

class NotificationModel {
  final String id;
  final String message;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.message,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      read: json['read'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class NotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final unreadCount = 0.obs;
  final _box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    isLoading.value = true;
    try {
      final token = _box.read('token') ?? '';
      final res = await NotificationService().getNotifications(token);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final notificationList = data['data'] as List? ?? [];
        notifications.assignAll(
          notificationList.map((n) => NotificationModel.fromJson(n)),
        );
        unreadCount.value = data['unread_count'] ?? 0;
      }
    } catch (e) {
      print('Error loading notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final token = _box.read('token') ?? '';
      final res = await NotificationService().markAsRead(token, notificationId);
      if (res.statusCode == 200) {
        final index = notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          notifications[index] = NotificationModel(
            id: notifications[index].id,
            message: notifications[index].message,
            read: true,
            createdAt: notifications[index].createdAt,
          );
          unreadCount.value = unreadCount.value > 0 ? unreadCount.value - 1 : 0;
        }
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final token = _box.read('token') ?? '';
      final res = await NotificationService().markAllAsRead(token);
      if (res.statusCode == 200) {
        notifications.assignAll(
          notifications.map(
            (n) => NotificationModel(
              id: n.id,
              message: n.message,
              read: true,
              createdAt: n.createdAt,
            ),
          ),
        );
        unreadCount.value = 0;
      }
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }
}
