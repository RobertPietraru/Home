import 'package:auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:household/household.dart';
import 'firebase_options.dart';

GetIt locator = GetIt.instance;

Future<void> initialize() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  authInject();
  householdInject();
}
