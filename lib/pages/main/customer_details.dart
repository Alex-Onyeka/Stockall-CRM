import 'package:flutter/material.dart';
import 'package:stockallcrm/classes/comment_class.dart';
import 'package:stockallcrm/classes/customers_class.dart';
import 'package:stockallcrm/components/alerts/call_whatsapp_alert.dart';
import 'package:stockallcrm/components/alerts/confirm_alert.dart';
import 'package:stockallcrm/components/alerts/create_comment.dart';
import 'package:stockallcrm/components/alerts/create_customer.dart';
import 'package:stockallcrm/components/alerts/info_alert_widget.dart';
import 'package:stockallcrm/components/alerts/select_status_alert_wdget.dart';
import 'package:stockallcrm/constants/formats.dart';
import 'package:stockallcrm/main.dart';
import 'package:stockallcrm/services/auth_service.dart';

class CustomerDetails extends StatefulWidget {
  final CustomerClass customer;
  const CustomerDetails({
    super.key,
    required this.customer,
  });

  @override
  State<CustomerDetails> createState() =>
      _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  bool isDeleteLoading = false;
  @override
  Widget build(BuildContext context) {
    CustomerClass? customerMain() {
      try {
        return returnCustomerProvider(
          context: context,
        ).customers.firstWhere(
          (cust) => cust.uuid == widget.customer.uuid,
        );
      } catch (e) {
        return null;
      }
    }

    var theme = returnThemeProvider();
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Visibility(
          visible:
              widget.customer.userId ==
                  AuthService().userId ||
              returnUserProvider().currentUser()?.name ==
                  'Alex Onyeka',
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return CreateCustomerAlert(
                    customer: customerMain(),
                  );
                },
              );
            },
            backgroundColor:
                theme.lightModeColor.prColor300,
            child: Icon(color: Colors.white, Icons.edit),
          ),
        ),
        body: Column(
          spacing: 5,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: const Color.fromARGB(
                      20,
                      0,
                      0,
                      0,
                    ),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      size: 18,
                      Icons.arrow_back_ios_new_rounded,
                    ),
                  ),
                  Text(
                    style: TextStyle(
                      fontSize:
                          theme.mobileTexts.h4.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    customerMain()?.name ?? 'Customer Name',
                  ),
                  Builder(
                    builder: (context) {
                      if (widget.customer.userId ==
                              AuthService().userId ||
                          returnUserProvider()
                                  .currentUser()
                                  ?.name ==
                              'Alex Onyeka') {
                        if (isDeleteLoading) {
                          return SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(
                                  color: theme
                                      .lightModeColor
                                      .secColor200,
                                  strokeWidth: 2,
                                ),
                          );
                        } else {
                          return IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (confirmContext) {
                                  return ConfirmAlert(
                                    title:
                                        'Delete Customer',
                                    message:
                                        'You are about to Delete This Customer. Are you sure you want to proceed?',
                                    action: () async {
                                      setState(() {
                                        isDeleteLoading =
                                            true;
                                      });
                                      var res =
                                          await returnCustomerProvider()
                                              .deleteCustomer(
                                                widget
                                                    .customer
                                                    .uuid!,
                                              );
                                      setState(() {
                                        isDeleteLoading =
                                            false;
                                      });
                                      if (res == 0) {
                                        showDialog(
                                          // ignore: use_build_context_synchronously
                                          context: context,
                                          builder: (errorContext) {
                                            return InfoAlertWidget(
                                              title:
                                                  'An Error Occoured',
                                              message:
                                                  'An Error Occoured While Deleting this customer. Please Try again.',
                                            );
                                          },
                                        );
                                      } else {
                                        if (confirmContext
                                            .mounted) {
                                          Navigator.of(
                                            confirmContext,
                                          ).pop();
                                        }
                                        if (context
                                            .mounted) {
                                          Navigator.of(
                                            context,
                                          ).pop();
                                        }
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              size: 20,
                              color: Colors.red.shade500,
                              Icons.delete_outline,
                            ),
                          );
                        }
                      } else {
                        return Opacity(
                          opacity: 0,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              size: 18,
                              Icons
                                  .arrow_back_ios_new_rounded,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                spacing: 5,
                children: [
                  CustomerHeadingContainer(
                    flex: 3,
                    creator:
                        returnUserProvider().users
                            .where(
                              (user) =>
                                  user.uuid ==
                                  customerMain()?.userId,
                            )
                            .isNotEmpty
                        ? returnUserProvider().users
                              .where(
                                (user) =>
                                    user.uuid ==
                                    customerMain()?.userId,
                              )
                              .first
                              .name
                        : 'Not Set',
                  ),
                  CustomerHeadingContainer(
                    flex: 3,
                    creator: customerMain()?.status == 1
                        ? 'New'
                        : customerMain()?.status == 2
                        ? 'Processing'
                        : 'Completed',
                    action: () {
                      showDialog(
                        context: context,
                        builder: (conContext) {
                          return SelectStatusAlertWdget(
                            title: 'Update Status',
                            message:
                                'Select the current Status of this marketing, to update.',
                            customer: customerMain()!,
                          );
                        },
                      );
                    },
                    icon: Icon(
                      color: Colors.grey,
                      size: 14,
                      Icons.edit,
                    ),
                  ),
                  CustomerHeadingContainer(
                    flex: 1,
                    action: () async {
                      showDialog(
                        context: context,
                        builder: (callContext) {
                          return CallWhatsappAlert(
                            customer: customerMain()!,
                            whatsapp: () {
                              openWhatsApp(
                                number:
                                    returnCustomerProvider(
                                          // context: context,
                                        ).customers
                                        .firstWhere(
                                          (cust) =>
                                              cust.uuid ==
                                              widget
                                                  .customer
                                                  .uuid,
                                        )
                                        .phone,
                              );
                            },
                            call: () {
                              phoneCall(
                                number:
                                    returnCustomerProvider(
                                          // context: context,
                                        ).customers
                                        .firstWhere(
                                          (cust) =>
                                              cust.uuid ==
                                              widget
                                                  .customer
                                                  .uuid,
                                        )
                                        .phone,
                              );
                              print(customerMain());
                            },
                          );
                        },
                      );
                    },
                    icon: Icon(
                      // color: Colors.grey,
                      size: 15,
                      Icons.phone,
                    ),
                    // date: customerMain()?.createdAt,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 0,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                spacing: 10,
                children: [
                  Text(
                    style: TextStyle(
                      fontSize:
                          theme.mobileTexts.b2.fontSize,
                      // fontWeight: FontWeight.bold,
                    ),
                    'Comments',
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (createCommentContext) {
                          return CreateComment(
                            customerUuid:
                                widget.customer.uuid!,
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        vertical: 5,
                        horizontal: 12,
                      ),
                      child: Row(
                        spacing: 3,
                        children: [
                          Icon(size: 16, Icons.add),
                          Text(
                            style: TextStyle(
                              fontSize: theme
                                  .mobileTexts
                                  .b3
                                  .fontSize,
                              fontWeight: FontWeight.bold,
                              color: theme
                                  .lightModeColor
                                  .secColor100,
                            ),
                            'Create Comment',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
              thickness: 2,
              height: 5,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20.0,
                  5,
                  20,
                  20,
                ),
                child: RefreshIndicator(
                  onRefresh: () {
                    return returnCommentProvider()
                        .getComments();
                  },
                  backgroundColor: Colors.white,
                  color: theme.lightModeColor.secColor200,
                  displacement: 10,
                  child: ListView(
                    children:
                        returnCommentProvider(
                              context: context,
                            )
                            .getCustomersComments(
                              widget.customer.uuid!,
                            )
                            .map(
                              (comt) =>
                                  CommentsListTileWidget(
                                    comment: comt,
                                  ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentsListTileWidget extends StatefulWidget {
  const CommentsListTileWidget({
    super.key,
    required this.comment,
  });

  final CommentClass comment;

  @override
  State<CommentsListTileWidget> createState() =>
      _CommentsListTileWidgetState();
}

class _CommentsListTileWidgetState
    extends State<CommentsListTileWidget> {
  bool isDeleteCommentLoading = false;
  bool isUpdateCommentLoading = false;
  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color.fromARGB(41, 12, 23, 148),
        ),
        color: const Color.fromARGB(10, 23, 36, 175),
      ),
      child: Column(
        spacing: 3,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  style: TextStyle(
                    fontSize: theme.mobileTexts.b3.fontSize,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade800,
                  ),
                  widget.comment.comment,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(height: 5),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            spacing: 5,
            children: [
              Row(
                spacing: 3,
                children: [
                  Text(
                    style: TextStyle(
                      fontSize:
                          theme.mobileTexts.b4.fontSize,
                      fontWeight: FontWeight.normal,
                      color:
                          theme.lightModeColor.secColor100,
                    ),
                    returnUserProvider().users
                            .where(
                              (us) =>
                                  us.uuid ==
                                  widget.comment.userId,
                            )
                            .isNotEmpty
                        ? returnUserProvider().users
                              .where(
                                (us) =>
                                    us.uuid ==
                                    widget.comment.userId,
                              )
                              .first
                              .name
                        : 'Not Set',
                  ),
                  Text(
                    style: TextStyle(
                      fontSize:
                          theme.mobileTexts.b4.fontSize,
                      fontWeight: FontWeight.normal,
                      color:
                          theme.lightModeColor.secColor100,
                    ),
                    '-',
                  ),
                  Text(
                    style: TextStyle(
                      fontSize:
                          theme.mobileTexts.b4.fontSize,
                      fontWeight: FontWeight.normal,
                      color:
                          theme.lightModeColor.secColor100,
                    ),
                    formatDateTimeTime(
                      widget.comment.createdAt,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Builder(
                    builder: (context) {
                      if (isUpdateCommentLoading) {
                        return Padding(
                          padding: const EdgeInsets.all(
                            8.0,
                          ),
                          child: SizedBox(
                            height: 17,
                            width: 17,
                            child:
                                CircularProgressIndicator(
                                  strokeWidth: 1.6,
                                  color: theme
                                      .lightModeColor
                                      .secColor200,
                                ),
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (confirmContext) {
                                return CreateComment(
                                  customerUuid: widget
                                      .comment
                                      .customerId,
                                  comment: widget.comment,
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            child: Icon(
                              size: 18,
                              color: Colors.grey,
                              Icons.edit,
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  Builder(
                    builder: (context) {
                      if (isDeleteCommentLoading) {
                        return Padding(
                          padding: const EdgeInsets.all(
                            8.0,
                          ),
                          child: SizedBox(
                            height: 17,
                            width: 17,
                            child:
                                CircularProgressIndicator(
                                  strokeWidth: 1.6,
                                  color: theme
                                      .lightModeColor
                                      .secColor200,
                                ),
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (confirmContext) {
                                return ConfirmAlert(
                                  title: 'Delete Comment',
                                  message:
                                      'You are about to delete this comment. Are you sure you want to proceed?',
                                  action: () async {
                                    setState(() {
                                      isDeleteCommentLoading =
                                          true;
                                    });
                                    var res =
                                        await returnCommentProvider()
                                            .deleteComment(
                                              widget
                                                  .comment
                                                  .uuid!,
                                            );

                                    if (res == 0 &&
                                        context.mounted) {
                                      setState(() {
                                        isDeleteCommentLoading =
                                            false;
                                      });
                                      showDialog(
                                        context: context,
                                        builder: (errorContext) {
                                          return InfoAlertWidget(
                                            title:
                                                'Error Occured',
                                            message:
                                                'An Error Occoured while trying to delete this comment. Please try again.',
                                          );
                                        },
                                      );
                                    } else {
                                      if (context.mounted) {
                                        setState(() {
                                          isDeleteCommentLoading =
                                              false;
                                        });
                                      }
                                    }
                                  },
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            child: Icon(
                              size: 18,
                              color: Colors.red.shade400,
                              Icons.delete_outline,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomerHeadingContainer extends StatelessWidget {
  const CustomerHeadingContainer({
    super.key,
    this.date,
    this.creator,
    this.action,
    this.icon,
    required this.flex,
  });

  final DateTime? date;
  final String? creator;
  final Function()? action;
  final Widget? icon;
  final int flex;

  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return Expanded(
      flex: flex,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: const Color.fromARGB(189, 4, 11, 88),
            ),
            color: const Color.fromARGB(24, 6, 13, 88),
          ),
          child: InkWell(
            onTap: action,
            child: Container(
              padding: EdgeInsets.all(5),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: icon != null ? 2 : 0,
                children: [
                  // Text(
                  //   style: TextStyle(
                  //     fontSize: theme.mobileTexts.b3.fontSize,
                  //   ),
                  //   creator != null ? 'Creator:' : 'Date:',
                  // ),
                  Visibility(
                    visible:
                        creator != null || date != null,
                    child: Text(
                      style: TextStyle(
                        fontSize:
                            theme.mobileTexts.b3.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      creator != null
                          ? creator ?? 'Creator'
                          : formatDateTime(
                              date ?? DateTime.now(),
                            ),
                    ),
                  ),
                  Visibility(
                    visible: icon != null,
                    child: icon ?? Container(),
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
