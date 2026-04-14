import 'package:flutter/material.dart';
import 'package:stockallcrm/pages/authentication/login_page.dart';
import 'package:stockallcrm/pages/authentication/sign_up_page.dart';

class AuthBase extends StatefulWidget {
  const AuthBase({super.key});

  @override
  State<AuthBase> createState() => _AuthBaseState();
}

class _AuthBaseState extends State<AuthBase> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  void toggleIsLogin() {
    _formKey.currentState?.reset();
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    setState(() {
      isLogin = !isLogin;
    });
  }

  final _formKey = GlobalKey<FormState>();

  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginPage(
        formKey: _formKey,
        action: () {
          toggleIsLogin();
        },
        emailController: emailController,
        passwordController: passwordController,
      );
    } else {
      return SignUpPage(
        action: () {
          toggleIsLogin();
        },
        emailController: emailController,
        passwordController: passwordController,
        nameController: nameController,
        confirmPasswordController:
            confirmPasswordController,
        formKey: _formKey,
      );
    }
  }
}
