// @dart = 2.9
import 'package:chat/models/receipt.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/receipt/receipt_service_contract.dart';
import 'package:chat_app/bloc/receipt/receipt_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeReceiptService extends Mock implements IReceiptService {}

void main() {
  ReceiptBloc bloc;
  IReceiptService receiptService;
  User user;

  setUp(() {
    receiptService = FakeReceiptService();
    user = User(
        userName: 'test', photoUrl: '', active: true, lastSeen: DateTime.now());
    bloc = ReceiptBloc(receiptService);
  });

  tearDown(() => receiptService.dispose());

  test('should emit init without subscription', () {
    expect(bloc.state, ReceiptInitial());
  });

  test('should emit receipt sent state when message is sent', () {
    final receipt = Receipt(
        recipient: '',
        messageId: '123',
        status: ReceiptStatus.sent,
        timeStamp: DateTime.now());
    when(receiptService.send(receipt)).thenAnswer((_) async => true);
    bloc.add(ReceiptSent(receipt));
    expect(bloc.stream, emits(ReceiptSentSuccess(receipt)));
  });

  test('should emit message received state when message is sent', () {
    final receipt = Receipt(
        recipient: '',
        messageId: '123',
        status: ReceiptStatus.sent,
        timeStamp: DateTime.now());
    when(receiptService.receipts(user))
        .thenAnswer((_) => Stream.fromIterable([receipt]));
    bloc.add(Subscribed(user));
    expect(bloc.stream, emitsInOrder([ReceiptReceivedSuccess(receipt)]));
  });
}
