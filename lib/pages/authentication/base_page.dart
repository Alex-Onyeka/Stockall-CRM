import 'package:flutter/material.dart';
import 'package:stockallcrm/main.dart';
import 'package:stockallcrm/pages/authentication/auth_base.dart';
import 'package:stockallcrm/pages/main/home.dart';
import 'package:stockallcrm/services/auth_service.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return GestureDetector(
      onTap: () =>
          FocusManager.instance.primaryFocus?.unfocus(),
      child: StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    color: theme.lightModeColor.secColor200,
                    strokeWidth: 2,
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      style: TextStyle(
                        fontSize:
                            theme.mobileTexts.b2.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      'An Error Occoured',
                    ),
                  ],
                ),
              ),
            );
          } else {
            if (snapshot.data?.session != null) {
              return Home();
            } else {
              return AuthBase();
            }
          }
        },
      ),
    );
  }
}
