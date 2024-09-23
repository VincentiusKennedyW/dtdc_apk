import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:dtdc/bloc/user_bloc/user_bloc.dart';
import 'package:dtdc/bloc/volunteers/volunteers_bloc.dart';
import 'package:dtdc/pages/auth/login_page.dart';
import 'package:dtdc/pages/main_page.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}

void main() async {
  Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();

  checkPermission();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<UserBloc>(
        create: (context) => UserBloc(),
      ),
      BlocProvider<VolunteersBloc>(
        create: (context) => VolunteersBloc(),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(GetUser());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(useMaterial3: true, colorScheme: const ColorScheme.light()),
      home: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/logo.png', // Ganti dengan path logo Anda
                      width: 100.0, // Adjust the width as needed
                      height: 100.0, // Adjust the height as needed
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Aplikasi DTDC',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Loading... ',
                    ),
                  ],
                ),
              ),
            );
          } else if (state is UserLoadSuccess) {
            return state.user.id != 0 ? MainPage() : const LoginPage();
          } else {
            return MainPage(
              error: true,
            );
          }
        },
      ),
      // home: MainPage(),
    );
  }
}

void checkPermission() async {
  final Location location = Location();
  late PermissionStatus permissionGranted;

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }
}
