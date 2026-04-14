import 'package:flutter/material.dart';
import 'package:stockallcrm/classes/customers_class.dart';
import 'package:stockallcrm/components/alerts/info_alert_widget.dart';
import 'package:stockallcrm/components/buttons/main_button.dart';
import 'package:stockallcrm/main.dart';

class SelectStatusAlertWdget extends StatefulWidget {
  const SelectStatusAlertWdget({
    super.key,
    required this.title,
    required this.message,
    required this.customer,
  });

  final String title;
  final String message;
  final CustomerClass customer;

  @override
  State<SelectStatusAlertWdget> createState() =>
      _SelectStatusAlertWdgetState();
}

class _SelectStatusAlertWdgetState
    extends State<SelectStatusAlertWdget> {
  int tempStatus = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        tempStatus = widget.customer.status;
      });
    });
  }

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
              widget.title,
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
                    widget.message,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(
                    106,
                    2,
                    21,
                    83,
                  ),
                ),
                color: const Color.fromARGB(17, 4, 29, 139),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 3,
                children: [
                  StatusSelectionList(
                    action: () {
                      setState(() {
                        tempStatus = 1;
                      });
                    },
                    title: 'New',
                    tempStatus: tempStatus,
                    myIndex: 1,
                  ),
                  StatusSelectionList(
                    action: () {
                      setState(() {
                        tempStatus = 2;
                      });
                    },
                    title: 'Processing',
                    tempStatus: tempStatus,
                    myIndex: 2,
                  ),
                  StatusSelectionList(
                    action: () {
                      setState(() {
                        tempStatus = 3;
                      });
                    },
                    title: 'Completed',
                    tempStatus: tempStatus,
                    myIndex: 3,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            MainButton(
              title: 'Update Status',
              action: () async {
                setState(() {
                  isLoading = true;
                });
                widget.customer.status = tempStatus;

                var res = await returnCustomerProvider()
                    .updateCustomer(
                      customer: widget.customer,
                    );

                if (res == 0) {
                  showDialog(
                    // ignore: use_build_context_synchronously
                    context: context,
                    builder: (errorContext) {
                      return InfoAlertWidget(
                        title: 'Error',
                        message:
                            'An Error Occoured While Updating this Status. Please try again.',
                      );
                    },
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class StatusSelectionList extends StatelessWidget {
  const StatusSelectionList({
    super.key,
    required this.title,
    required this.tempStatus,
    required this.myIndex,
    required this.action,
  });

  final int tempStatus;
  final int myIndex;
  final Function()? action;
  final String title;

  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action,
        child: SizedBox(
          height: 35,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              Text(
                style: TextStyle(
                  fontSize: theme.mobileTexts.b3.fontSize,
                  fontWeight: tempStatus == myIndex
                      ? FontWeight.bold
                      : null,
                ),
                title,
              ),
              Visibility(
                visible: tempStatus == myIndex,
                child: Icon(
                  size: 18,
                  color: theme.lightModeColor.secColor200,
                  Icons.check_box_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
