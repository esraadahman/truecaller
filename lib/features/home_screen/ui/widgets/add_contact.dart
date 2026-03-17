import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:truecaller/core/database/contact_model.dart';
import 'package:truecaller/core/database/database_helper.dart';
import 'package:truecaller/core/di/di.dart';
import 'package:truecaller/features/home_screen/logic/create_contact/cubit/create_contact_cubit.dart';
import 'package:truecaller/features/home_screen/logic/get_all_contacts/cubit/get_all_contacts_cubit.dart';

class AddContactDialog extends StatefulWidget {
  final VoidCallback? onContactAdded;

  const AddContactDialog({super.key, required this.onContactAdded});

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateContactCubit>(),
      child: BlocConsumer<CreateContactCubit, CreateContactState>(
        listener: (context, state) {
          if (state is CreateContactSuccess) {
            // if (!mounted) return;
            Navigator.pop(context);
            widget.onContactAdded?.call();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Contact added successfully')),
            );
          } else if (state is CreateContactFail) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {

          return 
          
          AlertDialog(
            title: const Text('Add Contact'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: context
                        .read<CreateContactCubit>()
                        .nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: context
                        .read<CreateContactCubit>()
                        .phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: context
                        .read<CreateContactCubit>()
                        .notesController,
                    decoration: const InputDecoration(
                      labelText: 'Last Follow Up Notes',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: context
                        .read<CreateContactCubit>()
                        .priorityController,
                    decoration: const InputDecoration(labelText: 'Priority'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: context
                        .read<CreateContactCubit>()
                        .stageController,
                    decoration: const InputDecoration(labelText: 'Stage'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CreateContactCubit>().addContact();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
