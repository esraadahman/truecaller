import 'package:truecaller/core/database/contact_model.dart';
import 'package:truecaller/core/database/database_helper.dart';

class HomeRepo {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  HomeRepo();

  Future<List<ContactModel>> getContacts() async {
    return await dbHelper.getAllContacts();
  }

  Future<void> addContact(ContactModel contact) async {
    await dbHelper.insertContact(contact);
  }

  // Later you can add:
  // Future<void> deleteContact(int id) async { ... }
  // Future<void> updateContact(ContactModel contact) async { ... }
}
