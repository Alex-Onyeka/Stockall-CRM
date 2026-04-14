import 'package:flutter/material.dart';
import 'package:stockallcrm/classes/comment_class.dart';
import 'package:stockallcrm/components/alerts/info_alert_widget.dart';
import 'package:stockallcrm/components/buttons/main_button.dart';
import 'package:stockallcrm/components/text_fields/general_textfield_only.dart';
import 'package:stockallcrm/main.dart';
import 'package:stockallcrm/services/auth_service.dart';

class CreateComment extends StatefulWidget {
  final String customerUuid;
  final CommentClass? comment;
  const CreateComment({
    super.key,
    required this.customerUuid,
    this.comment,
  });

  @override
  State<CreateComment> createState() =>
      _CreateCommentState();
}

class _CreateCommentState extends State<CreateComment> {
  final commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.comment != null) {
        commentController.text =
            widget.comment?.comment ?? '';
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      constraints: BoxConstraints(maxWidth: 400),
      content: GestureDetector(
        onTap: () =>
            FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          width: 400,
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(38, 0, 0, 0),
                blurRadius: 10,
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                spacing: 5,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    style: TextStyle(
                      fontSize:
                          theme.mobileTexts.h2.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    '${widget.comment != null ? 'Update' : 'Create'} Comment',
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
                            color: Colors.grey.shade700,
                            // fontWeight: FontWeight.bold,
                          ),
                          'Enter Comment Below to ${widget.comment != null ? 'Update' : 'Create'}',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  GeneralTextfieldOnly(
                    validatorAction: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Comment is required';
                      }
                      return null;
                    },
                    lines: 3,
                    controller: commentController,
                    theme: theme,
                    hint: 'Enter Comment',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                    ),
                    child: MainButton(
                      isLoading: isLoading,
                      title:
                          '${widget.comment != null ? 'Update' : 'Create'} Comment',
                      action: () async {
                        if (commentController
                            .text
                            .isNotEmpty) {
                          if (formKey.currentState!
                              .validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            var res = widget.comment == null
                                ? await returnCommentProvider()
                                      .createComment(
                                        CommentClass(
                                          createdAt:
                                              DateTime.now(),
                                          comment:
                                              commentController
                                                  .text
                                                  .trim(),
                                          userId:
                                              AuthService()
                                                  .userId!,
                                          customerId: widget
                                              .customerUuid,
                                        ),
                                      )
                                : await returnCommentProvider()
                                      .updateComment(
                                        CommentClass(
                                          uuid: widget
                                              .comment
                                              ?.uuid,
                                          createdAt:
                                              DateTime.now(),
                                          comment:
                                              commentController
                                                  .text
                                                  .trim(),
                                          userId:
                                              AuthService()
                                                  .userId!,
                                          customerId: widget
                                              .customerUuid,
                                        ),
                                      );
                            setState(() {
                              isLoading = false;
                            });
                            if (res == 0) {
                              showDialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                builder: (errorContext) {
                                  return InfoAlertWidget(
                                    title: 'Error',
                                    message:
                                        'An Error Occoured While ${widget.comment != null ? "Updating" : 'Creating'} this Comment. Please try again.',
                                  );
                                },
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
