part of 'list_dummy_bloc.dart';

sealed class ListDummyEvent extends Equatable {
  const ListDummyEvent();

  @override
  List<Object> get props => [];
}

class LoadDataEvent extends ListDummyEvent {
  final List<Map<String, dynamic>> data;

  const LoadDataEvent({required this.data});

  @override
  List<Object> get props => [data];
}
