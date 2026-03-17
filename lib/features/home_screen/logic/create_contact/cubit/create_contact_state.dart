part of 'create_contact_cubit.dart';

@immutable
sealed class CreateContactState {}

final class CreateContactInitial extends CreateContactState {}

final class CreateContactLoading extends CreateContactState {}

final class CreateContactSuccess extends CreateContactState {}

final class CreateContactFail extends CreateContactState {
  final String errorMessage;

  CreateContactFail({required this.errorMessage});
}
