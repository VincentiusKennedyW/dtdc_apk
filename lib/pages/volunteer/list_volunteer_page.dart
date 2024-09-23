import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtdc/bloc/volunteers/volunteers_bloc.dart';
import 'package:dtdc/model/Volunteer.dart';
import 'package:dtdc/pages/volunteer/detail_volunteer_page.dart';
import 'package:dtdc/pages/volunteer/form_volunteer_page.dart';

class ListVolunteerPage extends StatefulWidget {
  const ListVolunteerPage({super.key});

  @override
  State<ListVolunteerPage> createState() => _ListVolunteerPageState();
}

class _ListVolunteerPageState extends State<ListVolunteerPage> {
  int page = 1;
  late ScrollController _scrollController;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      page = page + 1;

      context.read<VolunteersBloc>().add(FetchMoreVolunteer(page: page));
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar DTDC'),
        centerTitle: true,
      ),
      body: BlocBuilder<VolunteersBloc, VolunteersState>(
        builder: (context, state) {
          if (state is VolunteersInitial || state is VolunteersLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is VolunteersLoadSuccess ||
              state is WaitingNewVolunteer) {
            List<Volunteer> listVolunteer = [];

            if (state is WaitingNewVolunteer) {
              listVolunteer = state.listVolunteer;
            } else if (state is VolunteersLoadSuccess) {
              listVolunteer = state.listVolunteer;
            }

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<VolunteersBloc>().add(GetListVolunteers());

                      setState(() {
                        page = 1;
                      });
                    },
                    child: ListView.separated(
                      controller:
                          listVolunteer.length > 9 ? _scrollController : null,
                      itemCount: listVolunteer.length,
                      separatorBuilder: (context, index) =>
                          const Divider(), // Menambahkan Divider
                      itemBuilder: (BuildContext context, int index) {
                        final item = listVolunteer[index];
                        return ListTile(
                          title: Text(item.status),
                          subtitle: Text(item.volunteerFamily![0].name ?? "-"),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailVolunteerPage(data: item),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                (state is WaitingNewVolunteer)
                    ? const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: SizedBox(
                          height: 40,
                          child: Text("Loading..."),
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          } else if (state is VolunteersLoadFailure) {
            return Center(
              child: Text('Failed to load ${state.error}'),
            );
          } else {
            return const Center(
              child: Text('Unknown state'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormVolunteerPage(),
            ),
          );
        },
      ),
    );
  }
}
