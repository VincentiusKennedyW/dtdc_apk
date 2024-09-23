import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dtdc/bloc/user_bloc/user_bloc.dart';
import 'package:dtdc/bloc/volunteers/volunteers_bloc.dart';
import 'package:dtdc/pages/auth/login_page.dart';
import 'package:dtdc/pages/tps/saksi_list_attachment_page.dart';
import 'package:dtdc/pages/volunteer/list_volunteer_page.dart';
import 'package:dtdc/pages/volunteer/map_volunteer_page.dart';

class MainPage extends StatefulWidget {
  bool error;

  MainPage({this.error = false, super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              context.read<UserBloc>().add(LogoutUser());

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const Row(
                children: [
                  Icon(Icons.logout, color: Colors.purple),
                  SizedBox(width: 5),
                  Text(
                    'Keluar',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white24,
      body: widget.error
          ? Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    Image.asset(
                      'assets/logo.png', // Replace with your logo asset path
                      width: 100.0, // Adjust the width as needed
                      height: 100.0, // Adjust the height as needed
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Aplikasi Relawan RT & Saksi TPS',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Connection failed please try again',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 15.0,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          widget.error = false;
                          // ignore: use_build_context_synchronously
                          context.read<UserBloc>().add(GetUser());
                        });
                      },
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amber,
                        ),
                        child: Text(
                          "Try Again",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Logo di bagian atas
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/logo.png', // Ganti dengan path logo Anda
                        width: 150,
                        height: 150,
                      ),
                    ),

                    // Spacer untuk memberi jarak antara logo dan tombol
                    const SizedBox(height: 50),

                    // Tombol Data Relawan
                    ElevatedButton(
                      onPressed: () {
                        final volunteer =
                            BlocProvider.of<VolunteersBloc>(context);
                        if (volunteer.state is! VolunteersLoadSuccess) {
                          context
                              .read<VolunteersBloc>()
                              .add(GetListVolunteers());
                        }

                        // Aksi ketika tombol ditekan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ListVolunteerPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Data DTDC'),
                    ),

                    const SizedBox(height: 20), // Jarak antar tombol

                    // Tombol Peta Relawan
                    ElevatedButton(
                      onPressed: () {
                        final volunteer =
                            BlocProvider.of<VolunteersBloc>(context);
                        if (volunteer.state is! VolunteersLoadSuccess) {
                          context
                              .read<VolunteersBloc>()
                              .add(GetListVolunteers());
                        }

                        // Aksi ketika tombol ditekan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MapVolunteerPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Peta Pesebaran Relawan'),
                    ),

                    const SizedBox(height: 20), // Jarak antar tombol

                    // Tombol Data TPS
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Aksi ketika tombol ditekan
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => SaksiListAttachmentPage()),
                    //     );
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 50, vertical: 20),
                    //     textStyle: const TextStyle(fontSize: 18),
                    //   ),
                    //   child: const Text('Data TPS'),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}
