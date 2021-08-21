import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/models/receipt.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/receipt/receipt_service_contract.dart';
import 'package:equatable/equatable.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  IReceiptService _receiptService;
  StreamSubscription? _streamSubscription;

  ReceiptBloc(this._receiptService) : super(ReceiptInitial());

  @override
  Stream<ReceiptState> mapEventToState(ReceiptEvent event) async* {
    if (event is Subscribed) {
      await _streamSubscription?.cancel();
      _streamSubscription =
          _receiptService.receipts(event.user).listen((receipt) {
        add(ReceiptReceived(receipt));
      });
    } else if (event is ReceiptReceived) {
      yield ReceiptReceivedSuccess(event.receipt);
    } else if (event is ReceiptSent) {
      await _receiptService.send(event.receipt);
      yield ReceiptSentSuccess(event.receipt);
    }
  }

  @override
  Future<void> close() async {
    _streamSubscription?.cancel();
    _receiptService.dispose();
    return super.close();
  }
}
