import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dtdc/model/Tps,.dart';

part 'list_tps_event.dart';
part 'list_tps_state.dart';

class ListTpsBloc extends Bloc<ListTpsEvent, ListTpsState> {
  final int _tpsPerPage = 10;
  int _currentPage = 0;

  ListTpsBloc() : super(ListTpsInitial()) {
    on<GetListTps>((event, emit) async {
      if (state is ListTpsLoadSuccess &&
          (state as ListTpsLoadSuccess).hasReachedMax) return;

      try {
        if (state is ListTpsInitial) {
          final listTps = await _fetchTpsList(0);
          return emit(
              ListTpsLoadSuccess(listTps: listTps, hasReachedMax: false));
        }

        final currentState = state as ListTpsLoadSuccess;
        final newListTps = await _fetchTpsList(_currentPage + 1);

        emit(newListTps.isEmpty
            ? currentState.copyWith(hasReachedMax: true)
            : ListTpsLoadSuccess(
                listTps: currentState.listTps + newListTps,
                hasReachedMax: false,
              ));

        _currentPage++;
      } catch (e) {
        emit(ListTpsLoadFailure(error: e.toString()));
      }
    });
  }

  Future<List<Tps>> _fetchTpsList(int page) async {
    // Simulate an API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulated TPS data, paginated
    final start = page * _tpsPerPage + 1;
    final end = start + _tpsPerPage;
    return List.generate(
      _tpsPerPage,
      (index) => Tps(
        id: start + index,
        name: 'TPS $index',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }
}
