part of 'list_tps_bloc.dart';

sealed class ListTpsEvent extends Equatable {
  const ListTpsEvent();

  @override
  List<Object> get props => [];
}

class GetListTps extends ListTpsEvent {}
