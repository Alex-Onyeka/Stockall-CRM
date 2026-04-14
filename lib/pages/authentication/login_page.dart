import 'package:flutter/material.dart';
import 'package:stockallcrm/components/alerts/info_alert_widget.dart';
import 'package:stockallcrm/components/buttons/main_button.dart';
import 'package:stockallcrm/components/text_fields/email_text_field.dart';
import 'package:stockallcrm/constants/formats.dart';
import 'package:stockallcrm/constants/images.dart';
import 'package:stockallcrm/main.dart';
import 'package:stockallcrm/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final Function()? action;

  const LoginPage({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    this.action,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                          'Login',
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
                                'Enter your email and password below to login.',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          spacing: 5,
                          children: [
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
                              onSubmit: (value) async {
                                if (widget
                                    .formKey
                                    .currentState!
                                    .validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var res = await AuthService()
                                      .signIn(
                                        widget
                                            .emailController
                                            .text,
                                        widget
                                            .passwordController
                                            .text,
                                      );

                                  if (res == 0) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (errorContext) {
                                        return InfoAlertWidget(
                                          message:
                                              'An error occoured while logging in. Please check your details and try again.',
                                          title:
                                              'An Error Occoured',
                                        );
                                      },
                                    );
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
                            title: 'Login',
                            action: () async {
                              if (widget
                                  .formKey
                                  .currentState!
                                  .validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                var res = await AuthService()
                                    .signIn(
                                      widget
                                          .emailController
                                          .text,
                                      widget
                                          .passwordController
                                          .text,
                                    );

                                if (res == 0) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (errorContext) {
                                      return InfoAlertWidget(
                                        message:
                                            'An error occoured while logging in. Please check your details and try again.',
                                        title:
                                            'An Error Occoured',
                                      );
                                    },
                                  );
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
                                  'Don\'t have an Account?',
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
                                  'Sign Up',
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
