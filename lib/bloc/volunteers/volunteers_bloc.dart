import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dtdc/model/Volunteer.dart';
import 'package:dtdc/model/VolunteerFamily.dart';
import 'package:dtdc/repositories/volunteer_repository.dart';
import 'package:dtdc/utils/auth.dart';

part 'volunteers_event.dart';
part 'volunteers_state.dart';

class VolunteersBloc extends Bloc<VolunteersEvent, VolunteersState> {
  VolunteersBloc() : super(VolunteersInitial()) {
    on<GetListVolunteers>((event, emit) async {
      String? token = await Auth().getToken();

      try {
        emit(VolunteersLoading());

        List<Volunteer> listVolunteer =
            await VolunteerRepository().getVolunteers(token ?? "", 1);

        print("banyak data: ${listVolunteer.length}");

        emit(VolunteersLoadSuccess(
          listVolunteer: listVolunteer,
          hasReachedMax: false,
        ));
      } catch (e) {
        emit(VolunteersLoadFailure(error: e.toString()));
      }
    });

    on<AddVolunteer>((event, emit) async {
      try {
        final currentState = state as VolunteersLoadSuccess;

        emit(VolunteersLoading());

        Volunteer volunteer = event.volunteer;

        // add new volunteer to the list
        List<Volunteer> newListVolunteer = currentState.listVolunteer;
        newListVolunteer.insert(0, volunteer);

        emit(VolunteersLoadSuccess(
            listVolunteer: newListVolunteer, hasReachedMax: false));
      } catch (e) {
        emit(VolunteersLoadFailure(error: e.toString()));
      }
    });

    on<FetchMoreVolunteer>((event, emit) async {
      if (state is VolunteersLoadSuccess &&
          !(state as VolunteersLoadSuccess).hasReachedMax) {
        String? token = await Auth().getToken();

        try {
          final currentState = state as VolunteersLoadSuccess;
          emit(WaitingNewVolunteer(listVolunteer: currentState.listVolunteer));

          List<Volunteer> fetchListVolunteer = await VolunteerRepository()
              .getVolunteers(token ?? "", event.page);

          if (fetchListVolunteer.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            print("banyak data baru: ${fetchListVolunteer.length}");

            List<Volunteer> newListVolunteer =
                currentState.listVolunteer + fetchListVolunteer;
            print("banyak data ganungan: ${newListVolunteer.length}");

            emit(VolunteersLoadSuccess(
              listVolunteer: newListVolunteer,
              hasReachedMax: false,
            ));
          }
        } catch (e) {
          emit(VolunteersLoadFailure(error: e.toString()));
        }
      }
    });
  }
}
