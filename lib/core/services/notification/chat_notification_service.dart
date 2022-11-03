import 'package:flutter/material.dart';
import 'package:flutter_chat/core/models/chat_notification.dart';

class ChatNotificationService with ChangeNotifier {
  List<ChatNotification> _items = [];

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
}