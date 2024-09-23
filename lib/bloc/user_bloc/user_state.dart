part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLogingIn extends UserState {}

class UserLoadSuccess extends UserState {
  final User user;

  const UserLoadSuccess(this.user);
}

class UserLoadFailure extends UserState {
  final String error;

  const UserLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load user {error: $error}';
  }
}
