part of 'list_tps_bloc.dart';

sealed class ListTpsState extends Equatable {
  const ListTpsState();

  @override
  List<Object> get props => [];
}

final class ListTpsInitial extends ListTpsState {}

final class ListTpsLoading extends ListTpsState {}

final class ListTpsLoadSuccess extends ListTpsState {
  final List<Tps> listTps;
  final bool hasReachedMax;

  ListTpsLoadSuccess copyWith({
    List<Tps>? listTps,
    bool? hasReachedMax,
  }) {
    return ListTpsLoadSuccess(
      listTps: listTps ?? this.listTps,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  const ListTpsLoadSuccess(
      {required this.listTps, required this.hasReachedMax});
}

final class ListTpsLoadFailure extends ListTpsState {
  final String error;

  const ListTpsLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load list tps {error: $error}';
  }
}
