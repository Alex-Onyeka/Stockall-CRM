import 'package:flutter/material.dart';
import 'package:stockallcrm/classes/user_class.dart';
import 'package:stockallcrm/components/alerts/info_alert_widget.dart';
import 'package:stockallcrm/main.dart';
import 'package:stockallcrm/pages/authentication/base_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  SupabaseClient get client => _client;

  Future<int> signUpAndCreateUser({
    required BuildContext context,
    required UserClass user,
  }) async {
    try {
      var account = await client
          .from('users')
          .select()
          .eq('email', user.email)
          .maybeSingle();
      if (account == null) {
        final signUpRes = await _client.auth.signUp(
          email: user.email,
          password: user.password,
        );

        final userId = signUpRes.user?.id;

        if (userId == null) {
          print('Failed to sign up user.');
          showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (context) {
              return InfoAlertWidget(
                message:
                    'Failed to create your account. Please check your details and try again.',
                title: 'An Error Occurred',
              );
            },
          );
          return 0;
        } else {
          user.uuid = userId;
          await returnUserProvider().createUser(user: user);
          return 1;
        }
      } else {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) {
            return InfoAlertWidget(
              message:
                  'This email is already Registered. Please check your email and try again.',
              title: 'Email Already Exists',
            );
          },
        );
        return 0;
      }
    } catch (e) {
      print('Error Creating User Account: ${e.toString()}');
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return InfoAlertWidget(
            message:
                'An Error occoured while creating your account. Please check your details and try again.',
            title: 'Error Creating Account',
          );
        },
      );
      return 0;
    }
  }

  Future<int> signIn(
    String email,
    String password,
    // BuildContext context,
  ) async {
    try {
      final authResponse = await _client.auth
          .signInWithPassword(
            email: email,
            password: password,
          );

      final user = authResponse.user;
      if (user == null) {
        print("No user returned from sign-in.");
      }

      return 1;
    } catch (e) {
      print("❌ Sign-in failed: ${e.toString()}");
      return 0;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _client.auth.signOut();
      returnUserProvider().clearAllUsers();
      returnCustomerProvider().clearAll();
      returnCommentProvider().clearAll();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (newContext) {
              return BasePage();
            },
          ),
          (route) => false,
        );
      } else {
        print('Context Not Mounted');
      }
    } catch (e) {}
  }

  String? get userId => _client.auth.currentUser?.id;
}
