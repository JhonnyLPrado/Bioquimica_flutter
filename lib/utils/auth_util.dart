// Some very simple utils about auth.
import 'package:pocketbase/pocketbase.dart';

// Takes a PocketBase connection
bool isAuth(PocketBase pb) {
  if (pb.authStore.isValid) {
    return true;
  }
  return false;
}
