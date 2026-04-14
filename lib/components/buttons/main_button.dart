import 'package:flutter/material.dart';
import 'package:stockallcrm/main.dart';

class MainButton extends StatelessWidget {
  const MainButton({
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
          color: theme.lightModeColor.prColor300,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: action,
          child: Container(
            padding: EdgeInsets.all(10),
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
                        color: Colors.white,
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
