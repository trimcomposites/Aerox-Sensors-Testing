import 'package:aerox_stage_1/features/feature_login/repository/remote/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginRepo extends Mock implements LoginRepository{}
class MockFirebaseUser extends Mock implements User {}

