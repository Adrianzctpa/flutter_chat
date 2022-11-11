import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/chat_notification.dart';

class ChatNotificationService with ChangeNotifier {
  final List<ChatNotification> _items = [];

  List<ChatNotification> get items => _items;

  int get itemsCount {
    return _items.length;
  }

  void add(ChatNotification item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(int i) {
    _items.removeAt(i);
    notifyListeners();
  }

  Future<void> init() async {
    await _configureForeground();
    await _configureBackground();
    await _configureExited();
  }

  Future<void> _configureForeground() async {
    if (await _requestPermissions()) {
      FirebaseMessaging.onMessage.listen(_messageHandler);
    }
  }

  Future<void> _configureBackground() async {
    if (await _requestPermissions()) {
      FirebaseMessaging.onMessageOpenedApp.listen(_messageHandler);
    }
  }

  Future<void> _configureExited() async {
    if (await _requestPermissions()) {
      RemoteMessage? initialNtf = await FirebaseMessaging.instance.getInitialMessage();

      if (initialNtf == null) return;

      _messageHandler(initialNtf);
    }
  }

  void _messageHandler(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    
    add(ChatNotification(
      title: notification.title ?? 'No title',
      body: notification.body ?? 'None',
    )); 
  }

  Future<bool> _requestPermissions() async {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}