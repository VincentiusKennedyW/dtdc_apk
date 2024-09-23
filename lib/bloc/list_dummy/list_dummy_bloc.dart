import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'list_dummy_event.dart';
part 'list_dummy_state.dart';

class ListDummyBloc extends Bloc<ListDummyEvent, ListDummyState> {
  ListDummyBloc() : super(ListDummyInitial()) {
    on<LoadDataEvent>((event, emit) {
      emit(ListDummyLoaded(data: event.data));
    });
  }
}
