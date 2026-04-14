import 'package:flutter/material.dart';
import 'package:stockallcrm/classes/user_class.dart';
import 'package:stockallcrm/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider extends ChangeNotifier {
  static final UserProvider _instance =
      UserProvider._internal();
  factory UserProvider() => _instance;
  UserProvider._internal();

  SupabaseClient supabase = Supabase.instance.client;

  final String tableName = 'users';

  List<UserClass> users = [];

  void clearAllUsers() {
    users.clear();
    print('All Users Cleared');
    notifyListeners();
  }

  UserClass? currentUser() {
    try {
      return users.firstWhere(
        (user) => user.uuid == AuthService().userId,
      );
    } catch (e) {
      print('Error Returning Current User');
      return null;
    }
  }

  List<UserClass> otherUsers() {
    try {
      users.sort((a, b) => a.name.compareTo(b.name));
      return users
          .where(
            (user) => user.uuid != AuthService().userId,
          )
          .toList();
    } catch (e) {
      print('Error Returning Other Users');
      return [];
    }
  }

  Future<int> createUser({required UserClass user}) async {
    try {
      var res = await supabase
          .from(tableName)
          .insert(user.toJson())
          .select()
          .maybeSingle();
      if (res == null) {
        print('User Creating Failed');
        return 0;
      }
      users.add(UserClass.fromJson(res));
      print('User Creating Success: ${user.name}');
      notifyListeners();
      return 1;
    } catch (e) {
      print('Error Creating User: ${e.toString()}');
      return 0;
    }
  }

  // Future<int> fetchUser() async {
  //   try {
  //     var res = await supabase
  //         .from(tableName)
  //         .select()
  //         .eq('uuid', AuthService().userId!)
  //         .maybeSingle();
  //     if (res == null) {
  //       print('User Fetching Failed');
  //       return 0;
  //     }

  //     user = UserClass.fromJson(res);
  //     print('User Fetching Success: ${user?.name}');
  //     notifyListeners();
  //     return 1;
  //   } catch (e) {
  //     print('Error Fetching User: ${e.toString()}');
  //     return 0;
  //   }
  // }

  Future<int> fetchAllUsers() async {
    try {
      var res = await supabase.from(tableName).select();
      if (res.isEmpty) {
        print('Users Fetching Failed');
        return 0;
      }

      users = res
          .map((re) => UserClass.fromJson(re))
          .toList();
      print('User Fetching Success: ${users.length}');
      notifyListeners();
      return 1;
    } catch (e) {
      print('Error Fetching User: ${e.toString()}');
      notifyListeners();
      return 0;
    }
  }
}
