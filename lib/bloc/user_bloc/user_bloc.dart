import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dtdc/model/User.dart';
import 'package:dtdc/repositories/user_repositry.dart';
import 'package:dtdc/utils/auth.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetUser>((event, emit) async {
      emit(UserLoading());
      try {
        String? token = await Auth().getToken();
        print(token);

        if (token == null) {
          emit(UserLoadSuccess(User.fromJson({})));
          return;
        }

        final User user = await UserRepository().getUser(token: token);

        if (user.id == 0) {
          emit(UserLoadSuccess(User.fromJson({})));
          return;
        }

        emit(UserLoadSuccess(user));
      } catch (error) {
        emit(UserLoadFailure(error: error.toString()));
      }
    });

    on<LogoutUser>((event, emit) async {
      try {
        await Auth().deleteToken();
        emit(UserLoadSuccess(User.fromJson({})));
      } catch (error) {
        emit(UserLoadFailure(error: error.toString()));
      }
    });
  }
}
