import 'package:flutter/material.dart';
import 'package:stockallcrm/classes/comment_class.dart';
import 'package:stockallcrm/classes/customers_class.dart';
import 'package:stockallcrm/components/alerts/info_alert_widget.dart';
import 'package:stockallcrm/components/buttons/main_button.dart';
import 'package:stockallcrm/components/text_fields/email_text_field.dart';
import 'package:stockallcrm/components/text_fields/general_textfield.dart';
import 'package:stockallcrm/components/text_fields/general_textfield_only.dart';
import 'package:stockallcrm/main.dart';
import 'package:stockallcrm/services/auth_service.dart';

class CreateCustomerAlert extends StatefulWidget {
  final CustomerClass? customer;
  const CreateCustomerAlert({super.key, this.customer});

  @override
  State<CreateCustomerAlert> createState() =>
      _CreateCustomerAlertState();
}

class _CreateCustomerAlertState
    extends State<CreateCustomerAlert> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.customer != null) {
        nameController.text = widget.customer?.name ?? '';
        emailController.text = widget.customer?.email ?? '';
        phoneController.text = widget.customer?.phone ?? '';
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
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    style: TextStyle(
                      fontSize:
                          theme.mobileTexts.h2.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    '${widget.customer != null ? 'Update' : 'Create'} Customer',
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
                          'Enter Customer Details Below to ${widget.customer != null ? 'Update' : 'Create'} Customer',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    spacing: 10,
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
                        controller: nameController,
                        theme: theme,
                        hint: 'Enter Name',
                        title: 'Name',
                      ),
                      GeneralTextField(
                        lines: 1,
                        validatorAction: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Phone Number is required';
                          }
                          return null;
                        },
                        controller: phoneController,
                        theme: theme,
                        hint: 'Enter Phone',
                        title: 'Phone',
                      ),
                      EmailTextField(
                        controller: emailController,
                        theme: theme,
                        isEmail: true,
                        hint: 'Enter Email (Optional)',
                        title: 'Email (Optional)',
                      ),
                      Visibility(
                        visible: widget.customer == null,
                        child: GeneralTextfieldOnly(
                          lines: 3,
                          controller: commentController,
                          theme: theme,
                          hint: 'Enter Comment',
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    child: MainButton(
                      isLoading: isLoading,
                      title:
                          '${widget.customer != null ? 'Update' : 'Create'} Account',
                      action: () async {
                        if (formKey.currentState!
                            .validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          if (widget.customer == null) {
                            var res = await returnCustomerProvider()
                                .createCustomer(
                                  comment:
                                      commentController
                                          .text
                                          .isNotEmpty
                                      ? CommentClass(
                                          createdAt:
                                              DateTime.now(),
                                          comment:
                                              commentController
                                                  .text
                                                  .trim(),
                                          userId:
                                              AuthService()
                                                  .userId!,
                                          customerId: '',
                                        )
                                      : null,
                                  customer: CustomerClass(
                                    status: 1,
                                    lastComment:
                                        DateTime.now(),
                                    createdAt:
                                        DateTime.now(),
                                    email: emailController
                                        .text
                                        .trim(),
                                    name: nameController
                                        .text
                                        .trim(),
                                    userId: AuthService()
                                        .userId!,
                                    phone: phoneController
                                        .text
                                        .trim(),
                                  ),
                                );
                            if (res == 0) {
                              setState(() {
                                isLoading = false;
                              });
                              showDialog(
                                context: context,
                                builder: (errorContext) {
                                  return InfoAlertWidget(
                                    title: 'Error',
                                    message:
                                        'An Error Occoured While Creating this Customer. Please try again.',
                                  );
                                },
                              );
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).pop();
                            }
                          } else {
                            var res =
                                await returnCustomerProvider()
                                    .updateCustomer(
                                      customer: CustomerClass(
                                        status: widget
                                            .customer!
                                            .status,
                                        lastComment: widget
                                            .customer!
                                            .lastComment,
                                        createdAt: widget
                                            .customer!
                                            .createdAt,
                                        email:
                                            emailController
                                                .text
                                                .trim(),
                                        name: nameController
                                            .text
                                            .trim(),
                                        userId: widget
                                            .customer!
                                            .userId,
                                        phone:
                                            phoneController
                                                .text
                                                .trim(),
                                        uuid: widget
                                            .customer!
                                            .uuid,
                                      ),
                                    );
                            if (res == 0) {
                              setState(() {
                                isLoading = false;
                              });
                              showDialog(
                                context: context,
                                builder: (errorContext) {
                                  return InfoAlertWidget(
                                    title: 'Error',
                                    message:
                                        'An Error Occoured While Updating this Customer. Please try again.',
                                  );
                                },
                              );
                            } else {
                              setState(() {
                                isLoading = false;
                              });
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
