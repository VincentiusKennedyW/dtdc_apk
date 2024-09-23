import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dtdc/bloc/list_tps/list_tps_bloc.dart';
import 'package:dtdc/model/Tps,.dart';

class ListTpsPage extends StatefulWidget {
  const ListTpsPage({super.key});

  @override
  State<ListTpsPage> createState() => _ListTpsPageState();
}

class _ListTpsPageState extends State<ListTpsPage> {
  late ListTpsBloc _tpsBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tpsBloc = ListTpsBloc()..add(GetListTps());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Fetch next page when reaching the end of the scroll
        _tpsBloc.add(GetListTps());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TPS List'),
      ),
      body: BlocBuilder<ListTpsBloc, ListTpsState>(
        bloc: _tpsBloc,
        builder: (context, state) {
          if (state is ListTpsInitial || state is ListTpsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ListTpsLoadSuccess) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.hasReachedMax
                  ? state.listTps.length
                  : state.listTps.length + 1,
              itemBuilder: (context, index) {
                Tps tps = state.listTps[index];
                return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(tps.name),
                );
              },
            );
          } else if (state is ListTpsLoadFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }
}
