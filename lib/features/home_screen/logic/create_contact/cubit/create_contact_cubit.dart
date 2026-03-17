import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:truecaller/core/database/contact_model.dart';
import 'package:truecaller/features/home_screen/data/repo/home_repo.dart';

part 'create_contact_state.dart';

class CreateContactCubit extends Cubit<CreateContactState> {
  CreateContactCubit(this.repo) : super(CreateContactInitial());

  final HomeRepo repo;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController priorityController = TextEditingController();
  final TextEditingController stageController = TextEditingController();

  //  close() {
  //   nameController.dispose();
  //   phoneController.dispose();
  //   notesController.dispose();
  //   priorityController.dispose();
  //   stageController.dispose();

  // }

  Future<void> addContact(
    //ContactModel contact
  ) async {
    try {
      emit(CreateContactLoading());
      await repo.addContact(
        ContactModel(
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          lastFollowUpNotes: notesController.text.trim().isEmpty
              ? null
              : notesController.text.trim(),
          priority: priorityController.text.trim().isEmpty
              ? null
              : priorityController.text.trim(),
          stage: stageController.text.trim().isEmpty
              ? null
              : stageController.text.trim(),
        ),
      );
      emit(CreateContactSuccess());
    } catch (e) {
      emit(CreateContactFail(errorMessage: e.toString()));
    }
  }
}
