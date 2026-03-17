part of 'get_all_contacts_cubit.dart';

@immutable
sealed class GetAllContactsState {}

final class GetAllContactsInitial extends GetAllContactsState {}

final class GetAllContactsLoading extends GetAllContactsState {}

final class GetAllContactsSuccess extends GetAllContactsState {
  final List<ContactModel> contactList;

  GetAllContactsSuccess({required this.contactList});
}

final class GetAllContactsFailer extends GetAllContactsState {
  final String errorMessage;

  GetAllContactsFailer({required this.errorMessage});
}
