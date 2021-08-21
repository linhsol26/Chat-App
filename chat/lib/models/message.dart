class Message {
  final String from;
  final String to;
  final DateTime timeStamp;
  final String contents;
  late String _id;

  String get id => _id;

  Message({
    required this.from,
    required this.to,
    required this.timeStamp,
    required this.contents,
  });

  toJson() => {
        'from': this.from,
        'to': this.to,
        'timeStamp': this.timeStamp,
        'contents': this.contents
      };

  factory Message.fromJson(Map<String, dynamic> json) {
    var message = Message(
        from: json['from'],
        to: json['to'],
        timeStamp: json['timeStamp'],
        contents: json['contents']);

    message._id = json['id'];
    return message;
  }
}
