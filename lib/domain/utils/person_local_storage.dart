import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/concepts/person.dart';

/// Save Person locally for next app session
Future<void> savePersonLocally(Person person) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("firstName", person.firstName ?? "");
  await prefs.setString("lastName", person.lastName ?? "");
  await prefs.setString("uid", person.uid ?? "");
}

/// Load saved person (used in home_page)
Future<Person?> loadPersonLocally() async {
  final prefs = await SharedPreferences.getInstance();

  final f = prefs.getString("firstName");
  final l = prefs.getString("lastName");
  final u = prefs.getString("uid");

  if (f == null || l == null || u == null) return null;

  return Person(firstName: f, lastName: l, uid: u);
}
