part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object> get props => [];
}

class Subscribed extends ReceiptEvent {
  final User user;

  Subscribed(this.user);

  @override
  List<Object> get props => [user];
}

class ReceiptSent extends ReceiptEvent {
  final Receipt receipt;

  ReceiptSent(this.receipt);

  @override
  List<Object> get props => [receipt];
}

class ReceiptReceived extends ReceiptEvent {
  final Receipt receipt;

  ReceiptReceived(this.receipt);

  @override
  List<Object> get props => [receipt];
}
