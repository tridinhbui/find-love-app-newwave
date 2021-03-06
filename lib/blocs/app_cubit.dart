import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_base_bloc/models/entities/export_entity.dart';

import '../models/enums/load_status.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import '../utils/logger.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  UserRepository? userRepository;
  AuthRepository? authRepository;

  AppCubit({this.userRepository, this.authRepository}) : super(AppState());

  void fetchProfile() {
    emit(state.copyWith(fetchProfileStatus: LoadStatus.LOADING));
  }

  void updateProfile(UserEntity user) {
    emit(state.copyWith(user: user));
  }

  ///Sign Out
  void signOut() async {
    emit(state.copyWith(signOutStatus: LoadStatus.LOADING));
    try {
      //Todo
      await Future.delayed(Duration(seconds: 2));
      await authRepository?.removeToken();
      emit(state.removeUser());
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(signOutStatus: LoadStatus.FAILURE));
    }
  }
}
