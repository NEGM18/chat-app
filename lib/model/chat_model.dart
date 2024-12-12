class Message {
  final String message;
  final String id;
  final String docid;
  bool isStarred; 

  Message({
    required this.message,
    required this.id,
    required this.docid,
    this.isStarred = false, 
  });

  
  void toggleStar() {
    isStarred = !isStarred;
  }

  
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'id': id,
      'created at': DateTime.now(),
      'isStarred': isStarred, 
    };
  }

  
  factory Message.fromJson(Map<String, dynamic> json, String docid) {
    return Message(
      message: json['message'],
      id: json['id'],
      docid: docid,
      isStarred: json['isStarred'] ?? false, 
    );
  }
}
