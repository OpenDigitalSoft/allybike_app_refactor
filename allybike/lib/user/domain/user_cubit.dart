import 'package:allybike/user/models/user.model.dart';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'user_state.dart';

@lazySingleton
class UserCubit extends HydratedCubit<UserState> {
  UserCubit() : super(UserInitial());

  setUser(User user) {
    emit(GetUserSuccess(user: user));
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) {
     return GetUserSuccess(user: User.fromJson(json["user"]));
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    if (state is GetUserSuccess) {
      return {"user": state.user.toJson()};
    }
    return null;
  }
}
