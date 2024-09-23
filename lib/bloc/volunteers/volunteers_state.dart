part of 'volunteers_bloc.dart';

sealed class VolunteersState extends Equatable {
  const VolunteersState();

  @override
  List<Object> get props => [];
}

final class VolunteersInitial extends VolunteersState {}

final class VolunteersLoading extends VolunteersState {}

final class VolunteersLoadSuccess extends VolunteersState {
  final List<Volunteer> listVolunteer;
  final bool hasReachedMax;

  VolunteersLoadSuccess copyWith({
    List<Volunteer>? listVolunteer,
    bool? hasReachedMax,
  }) {
    return VolunteersLoadSuccess(
      listVolunteer: listVolunteer ?? this.listVolunteer,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  const VolunteersLoadSuccess(
      {required this.listVolunteer, required this.hasReachedMax});
}

final class WaitingNewVolunteer extends VolunteersState {
  final List<Volunteer> listVolunteer;

  const WaitingNewVolunteer({required this.listVolunteer});
}

final class VolunteersLoadFailure extends VolunteersState {
  final String error;

  const VolunteersLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load list tps {error: $error}';
  }
}
