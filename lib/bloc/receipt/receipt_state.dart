part of 'receipt_bloc.dart';

abstract class ReceiptState extends Equatable {
  const ReceiptState();

  @override
  List<Object> get props => [];
}

class ReceiptInitial extends ReceiptState {}

class ReceiptSentSuccess extends ReceiptState {
  final Receipt receipt;

  ReceiptSentSuccess(this.receipt);

  @override
  List<Object> get props => [receipt];
}

class ReceiptReceivedSuccess extends ReceiptState {
  final Receipt receipt;

  ReceiptReceivedSuccess(this.receipt);

  @override
  List<Object> get props => [receipt];
}
