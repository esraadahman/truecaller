import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:truecaller/core/database/contact_model.dart';
import 'package:truecaller/core/database/database_helper.dart';
import 'package:truecaller/core/di/di.dart';
import 'package:truecaller/core/overlay_helper/permations_check.dart';
import 'package:truecaller/core/routing/navigate.dart';
import 'package:truecaller/core/services/phone_state_service.dart';
import 'package:truecaller/features/home_screen/logic/create_contact/cubit/create_contact_cubit.dart';
import 'package:truecaller/features/home_screen/logic/get_all_contacts/cubit/get_all_contacts_cubit.dart';
import 'package:truecaller/features/home_screen/ui/widgets/add_contact.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // @override
  // void initState() {
  //   super.initState();

  //   _initOverlayAndPhoneState();
  // }

  // Future<void> _initOverlayAndPhoneState() async {
  //  // await DatabaseHelper.instance.database;
  //   await checkOverlayPermissionOnce();
  //   await PhoneStateService.init();
  // }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<GetAllContactsCubit>()),
        BlocProvider(create: (context) => getIt<CreateContactCubit>()),
      ],
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //      context.navigateTo(test());
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   if (!context.mounted) return;
            showDialog(
              context: context,
              builder: (_) => AddContactDialog(
                onContactAdded: () {
                  context.read<GetAllContactsCubit>().fetchContacts();
                },
              ),
            );
            // });
          },
          child: Icon(Icons.add),
        ),
        body: BlocBuilder<GetAllContactsCubit, GetAllContactsState>(
          builder: (context, state) {
            if (state is GetAllContactsLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is GetAllContactsSuccess) {
              return
              // Column(
              //   children: [
              //  TextField(),
              // SizedBox(
              //   height: in,
              // child:
              ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: state.contactList.length,
                itemBuilder: (context, index) {
                  final contact = state.contactList[index];
                  return CardWidget(contact: contact);
                },
                //  ),
                //   ),
                // ],
              );
            }
            if (state is GetAllContactsFailer) {
              return Center(child: Text('Error: //${state.errorMessage}'));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}

// class test extends StatelessWidget {
//   const test({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: AppBar(title: Text("data")));
//   }
// }

class CardWidget extends StatelessWidget {
  CardWidget({super.key, required this.contact});

  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            contact.name,
            style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),

          // Phone
          Row(
            children: [
              Icon(Icons.phone, size: 16.w, color: Colors.grey),
              SizedBox(width: 6.h),
              Text(contact.phone),
            ],
          ),
          SizedBox(height: 6.h),

          // Priority & Stage
          Row(
            children: [
              if (contact.priority != null && contact.priority!.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    contact.priority!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              SizedBox(width: 8),
              if (contact.stage != null && contact.stage!.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    contact.stage!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
          SizedBox(height: 6),

          // Last follow-up notes
          if (contact.lastFollowUpNotes != null &&
              contact.lastFollowUpNotes!.isNotEmpty)
            Text(
              "Notes: ${contact.lastFollowUpNotes!}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
