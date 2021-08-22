import 'package:bloc/bloc.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/user/user_service_contract.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  IUserService _userService;

  HomeCubit(this._userService) : super(HomeInitial());

  Future<void> activeUsers() async {
    emit(HomeLoading());
    final users = await _userService.online();
    emit(HomeSuccess(users));
  }
}
