// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'auth_cubit.dart';

class AuthState {
  final User? user;
  const AuthState({
    this.user,
  });

  @override
  String toString() => 'AuthState(user: $user)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user?.toMap(),
    };
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      user: User.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthState.fromJson(String source) =>
      AuthState.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AuthLoggedIn extends AuthState {
  const AuthLoggedIn({required super.user});
}

class AuthInitial extends AuthState {
  const AuthInitial();
}
