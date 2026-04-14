import 'package:flutter/material.dart';
import 'package:stockallcrm/main.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.title,
    required this.isLoading,
    this.action,
  });

  final String title;
  final Function()? action;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // color: ,
          border: Border.all(
            color: theme.lightModeColor.prColor300,
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            if (action == null) {
              Navigator.of(context).pop();
            } else {
              action!();
            }
          },
          child: Container(
            padding: EdgeInsets.all(8),
            child: Center(
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    return SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: theme
                            .lightModeColor
                            .secColor200,
                      ),
                    );
                  } else {
                    return Text(
                      style: TextStyle(
                        fontSize:
                            theme.mobileTexts.b2.fontSize,
                        color:
                            theme.lightModeColor.prColor300,
                        fontWeight: FontWeight.w600,
                      ),
                      title,
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
