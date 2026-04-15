import 'package:flutter/material.dart';
import 'package:stockallcrm/classes/customers_class.dart';
import 'package:stockallcrm/components/buttons/secondary_button.dart';
import 'package:stockallcrm/main.dart';

class CallWhatsappAlert extends StatelessWidget {
  const CallWhatsappAlert({
    super.key,
    required this.call,
    required this.whatsapp,
    required this.customer,
  });

  final CustomerClass customer;
  final Function()? call;
  final Function()? whatsapp;

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
          spacing: 0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5),
            Text(
              style: TextStyle(
                fontSize: theme.mobileTexts.h3.fontSize,
                fontWeight: FontWeight.bold,
              ),
              customer.name,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          theme.mobileTexts.b1.fontSize,
                      color: Colors.grey.shade800,
                      // fontWeight: FontWeight.bold,
                    ),
                    customer.phone,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
              ),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: whatsapp,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(3),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              style: TextStyle(
                                fontSize: theme
                                    .mobileTexts
                                    .b3
                                    .fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              'Whatsapp',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: call,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(3),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              style: TextStyle(
                                fontSize: theme
                                    .mobileTexts
                                    .b3
                                    .fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              'Call',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1),
            SecondaryButton(
              title: 'Cancel',
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }
}
