enum ReceiptStatus { sent, deliverred, read }

class Receipt {
  final String recipient;
  final String messageId;
  final ReceiptStatus status;
  final DateTime timeStamp;
  late String _id;
  String get id => _id;

  Receipt({
    required this.recipient,
    required this.messageId,
    required this.status,
    required this.timeStamp,
  });

  Map<String, dynamic> toJson() => {
        'recipient': this.recipient,
        'message_id': this.messageId,
        'status': this.status.value(),
        'timestamp': timeStamp
      };

  factory Receipt.fromJson(Map<String, dynamic> json) {
    var receipt = Receipt(
        recipient: json['recipient'],
        messageId: json['message_id'],
        status: EnumParsing.fromString(json['status']),
        timeStamp: json['timestamp']);
    receipt._id = json['id'];
    return receipt;
  }
}

extension EnumParsing on ReceiptStatus {
  String value() {
    return this.toString().split('.').last;
  }

  static ReceiptStatus fromString(String status) {
    return ReceiptStatus.values
        .firstWhere((element) => element.value() == status);
  }
}
