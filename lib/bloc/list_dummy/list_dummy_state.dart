part of 'list_dummy_bloc.dart';

sealed class ListDummyState extends Equatable {
  const ListDummyState();

  @override
  List<Object> get props => [];
}

final class ListDummyInitial extends ListDummyState {}

final class ListDummyLoaded extends ListDummyState {
  final List<Map<String, dynamic>> data;

  const ListDummyLoaded({required this.data});

  @override
  List<Object> get props => [data];
}
