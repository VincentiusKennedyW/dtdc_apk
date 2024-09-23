part of 'volunteers_bloc.dart';

sealed class VolunteersEvent extends Equatable {
  const VolunteersEvent();

  @override
  List<Object> get props => [];
}

class GetListVolunteers extends VolunteersEvent {}

class AddVolunteer extends VolunteersEvent {
  final Volunteer volunteer;

  const AddVolunteer({required this.volunteer});

  @override
  List<Object> get props => [volunteer];
}

class FetchMoreVolunteer extends VolunteersEvent {
  final int page;
  const FetchMoreVolunteer({required this.page});
}
