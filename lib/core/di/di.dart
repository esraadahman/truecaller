import 'package:get_it/get_it.dart';
import 'package:truecaller/core/database/database_helper.dart';
import 'package:truecaller/features/home_screen/data/repo/home_repo.dart';
import 'package:truecaller/features/home_screen/logic/create_contact/cubit/create_contact_cubit.dart';
import 'package:truecaller/features/home_screen/logic/get_all_contacts/cubit/get_all_contacts_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // home
  getIt.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);
  getIt.registerLazySingleton<HomeRepo>(() => HomeRepo());

  getIt.registerFactory<CreateContactCubit>(
    () => CreateContactCubit(getIt<HomeRepo>()),
  );

  getIt.registerFactory<GetAllContactsCubit>(
    () => GetAllContactsCubit(getIt<HomeRepo>()),
  );
}
