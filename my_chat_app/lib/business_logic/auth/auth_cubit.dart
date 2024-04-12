import 'dart:convert';

import 'package:my_chat_app/data_layer/models/user_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  void login(Map<String, String> userMap) {
    emit(AuthLoggedIn(user: User.fromMap(userMap)));
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    print("Retrieving saved state $json");
    return AuthState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    print("Saving new state $state");
    return state.toMap();
  }
}
