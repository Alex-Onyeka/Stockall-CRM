import 'package:flutter/material.dart';
import 'package:stockallcrm/classes/user_class.dart';
import 'package:stockallcrm/components/buttons/main_button.dart';
import 'package:stockallcrm/components/text_fields/email_text_field.dart';
import 'package:stockallcrm/components/text_fields/general_textfield.dart';
import 'package:stockallcrm/constants/formats.dart';
import 'package:stockallcrm/constants/images.dart';
import 'package:stockallcrm/main.dart';
import 'package:stockallcrm/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;
  final Function()? action;

  const SignUpPage({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.confirmPasswordController,
    required this.formKey,
    this.action,
  });

  @override
  State<SignUpPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignUpPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image.asset(height: 36, logo),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          17,
                          0,
                          0,
                          0,
                        ),
                        blurRadius: 10,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Form(
                    key: widget.formKey,
                    child: Column(
                      spacing: 10,
                      children: [
                        Text(
                          style: TextStyle(
                            fontSize: theme
                                .mobileTexts
                                .h1
                                .fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          'Sign Up',
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: theme
                                      .mobileTexts
                                      .b3
                                      .fontSize,
                                  color: Colors.grey,
                                  // fontWeight: FontWeight.bold,
                                ),
                                'Enter your Account Information below to Create your account.',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          spacing: 5,
                          children: [
                            GeneralTextField(
                              lines: 1,
                              validatorAction: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                              controller:
                                  widget.nameController,
                              theme: theme,
                              hint: 'Enter Name',
                              title: 'Name',
                            ),
                            EmailTextField(
                              validatorAction: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!checkValidEmail(
                                  value,
                                )) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                              controller:
                                  widget.emailController,
                              theme: theme,
                              isEmail: true,
                              hint: 'Enter Email',
                              title: 'Email',
                            ),
                            EmailTextField(
                              validatorAction: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 6) {
                                  return 'Password Must be 6 Chars. or more';
                                }
                                return null;
                              },
                              controller:
                                  widget.passwordController,
                              theme: theme,
                              isEmail: false,
                              hint: 'Enter Password',
                              title: 'Password',
                            ),
                            EmailTextField(
                              validatorAction: (value) {
                                if (value == null ||
                                    value.isEmpty) {
                                  return 'Confirm Password is required';
                                }
                                if (value !=
                                    widget
                                        .passwordController
                                        .text) {
                                  return 'Password Mismatch!';
                                }
                                return null;
                              },
                              controller: widget
                                  .confirmPasswordController,
                              theme: theme,
                              isEmail: false,
                              hint: 'Confirm Password',
                              title: 'Confirm Password',
                              onSubmit: (value) async {
                                if (widget
                                    .formKey
                                    .currentState!
                                    .validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var res = await AuthService()
                                      .signUpAndCreateUser(
                                        context: context,
                                        user: UserClass(
                                          email: widget
                                              .emailController
                                              .text
                                              .trim(),
                                          createdAt:
                                              DateTime.now(),
                                          name: widget
                                              .nameController
                                              .text
                                              .trim(),
                                          password: widget
                                              .passwordController
                                              .text
                                              .trim(),
                                        ),
                                      );
                                  if (res == 0) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: MainButton(
                            isLoading: isLoading,
                            title: 'Create Account',
                            action: () async {
                              if (widget
                                  .formKey
                                  .currentState!
                                  .validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                var res = await AuthService()
                                    .signUpAndCreateUser(
                                      context: context,
                                      user: UserClass(
                                        email: widget
                                            .emailController
                                            .text
                                            .trim(),
                                        createdAt:
                                            DateTime.now(),
                                        name: widget
                                            .nameController
                                            .text
                                            .trim(),
                                        password: widget
                                            .passwordController
                                            .text
                                            .trim(),
                                      ),
                                    );
                                if (res == 0) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        InkWell(
                          onTap: widget.action,
                          child: Padding(
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              spacing: 4,
                              children: [
                                Text(
                                  textAlign:
                                      TextAlign.center,
                                  style: TextStyle(
                                    fontSize: theme
                                        .mobileTexts
                                        .b3
                                        .fontSize,
                                    color: Colors.grey,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                  'Do you have an Account?',
                                ),
                                Text(
                                  textAlign:
                                      TextAlign.center,
                                  style: TextStyle(
                                    fontSize: theme
                                        .mobileTexts
                                        .b3
                                        .fontSize,
                                    fontWeight:
                                        FontWeight.bold,
                                    color: theme
                                        .lightModeColor
                                        .secColor100,
                                  ),
                                  'Login',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
