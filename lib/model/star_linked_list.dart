import 'package:chat/model/chat_model.dart';
class MessageNode {
  Message message;
  MessageNode? next;
  MessageNode(this.message, {this.next});
}
class StarredMessagesLinkedList {
  MessageNode? head;
  void add(Message message) {
    MessageNode newNode = MessageNode(message);
    if (head == null) {
      head = newNode;
    } else {
      MessageNode? current = head;
      while (current?.next != null) {
        current = current?.next;
      }
      current?.next = newNode;
    }
  }
  void remove(Message message) {
    if (head == null) return;
    if (head!.message == message) {
      head = head?.next;
      return;
    }
    MessageNode? current = head;
    while (current?.next != null) {
      if (current?.next?.message == message) {
        current?.next = current?.next?.next;
        return;
      }
      current = current?.next;
    }
  }
  bool contains(Message message) {
    MessageNode? current = head;
    while (current != null) {
      if (current.message == message) {
        return true;
      }
      current = current.next;
    }
    return false;
  }
  void display() {
    MessageNode? current = head;
    while (current != null) {
      print(current.message.message);
      current = current.next;
    }
  }
}
