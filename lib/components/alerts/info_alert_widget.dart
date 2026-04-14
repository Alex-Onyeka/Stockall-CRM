import 'package:flutter/material.dart';
import 'package:stockallcrm/components/buttons/main_button.dart';
import 'package:stockallcrm/main.dart';

class InfoAlertWidget extends StatelessWidget {
  const InfoAlertWidget({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return AlertDialog(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(maxWidth: 400),
      contentPadding: EdgeInsets.all(0),
      insetPadding: EdgeInsets.all(0),
      content: Container(
        width: 400,
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(17, 0, 0, 0),
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            Text(
              style: TextStyle(
                fontSize: theme.mobileTexts.h1.fontSize,
                fontWeight: FontWeight.bold,
              ),
              title,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          theme.mobileTexts.b2.fontSize,
                      color: Colors.grey,
                      // fontWeight: FontWeight.bold,
                    ),
                    message,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            MainButton(
              title: 'Cancel',
              action: () {
                Navigator.of(context).pop();
              },
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }
}
