import 'package:flutter/material.dart';
import 'package:stockallcrm/components/buttons/main_button.dart';
import 'package:stockallcrm/main.dart';

class SelectBatchAlertWidget extends StatefulWidget {
  const SelectBatchAlertWidget({
    super.key,
    required this.title,
    required this.message,
    this.batch,
  });

  final String title;
  final String message;
  final int? batch;

  @override
  State<SelectBatchAlertWidget> createState() =>
      _SelectBatchAlertWidgetState();
}

class _SelectBatchAlertWidgetState
    extends State<SelectBatchAlertWidget> {
  int? tempbatch;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.batch != null) {
          tempbatch = widget.batch ?? 0;
        } else {
          tempbatch =
              returnCustomerProvider().currentBatch ?? 0;
        }
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
                        tempbatch = 0;
                      });
                    },
                    title: 'All Batches',
                    tempbatch: tempbatch ?? 0,
                    myIndex: 0,
                  ),
                  StatusSelectionList(
                    action: () {
                      setState(() {
                        tempbatch = 1;
                      });
                    },
                    title: 'Batch 1',
                    tempbatch: tempbatch ?? 0,
                    myIndex: 1,
                  ),
                  StatusSelectionList(
                    action: () {
                      setState(() {
                        tempbatch = 2;
                      });
                    },
                    title: 'Batch 2',
                    tempbatch: tempbatch ?? 0,
                    myIndex: 2,
                  ),
                  StatusSelectionList(
                    action: () {
                      setState(() {
                        tempbatch = 3;
                      });
                    },
                    title: 'Batch 3',
                    tempbatch: tempbatch ?? 0,
                    myIndex: 3,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            MainButton(
              title: widget.batch != null
                  ? 'Update Batch'
                  : 'Select Batch',
              action: () async {
                if (widget.batch == null) {
                  returnCustomerProvider().selectBatch(
                    tempbatch == 0 ? null : tempbatch,
                  );
                } else {
                  returnCustomerProvider().selectTempBatch(
                    tempbatch,
                  );
                }
                Navigator.of(context).pop();
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
    required this.tempbatch,
    required this.myIndex,
    required this.action,
  });

  final int tempbatch;
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
                  fontWeight: tempbatch == myIndex
                      ? FontWeight.bold
                      : null,
                ),
                title,
              ),
              Visibility(
                visible: tempbatch == myIndex,
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
