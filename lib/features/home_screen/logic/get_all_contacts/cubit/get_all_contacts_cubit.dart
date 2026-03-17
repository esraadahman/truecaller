import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:truecaller/core/database/contact_model.dart';
import 'package:truecaller/features/home_screen/data/repo/home_repo.dart';

part 'get_all_contacts_state.dart';

class GetAllContactsCubit extends Cubit<GetAllContactsState> {
  GetAllContactsCubit(this.repo) : super(GetAllContactsInitial()) {
    fetchContacts();
  }
  final HomeRepo repo;
  Future<void> fetchContacts() async {
    try {
      emit(GetAllContactsLoading());
      final contacts = await repo.getContacts();
      emit(GetAllContactsSuccess(contactList: contacts));
    } catch (e) {
      emit(GetAllContactsFailer(errorMessage: e.toString()));
    }
  }
}
