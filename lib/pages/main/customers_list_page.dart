import 'package:flutter/material.dart';
import 'package:stockallcrm/components/alerts/create_customer.dart';
import 'package:stockallcrm/components/text_fields/general_textfield_only.dart';
import 'package:stockallcrm/constants/formats.dart';
import 'package:stockallcrm/main.dart';
import 'package:stockallcrm/pages/main/customer_details.dart';
import 'package:stockallcrm/services/auth_service.dart';

class CustomersListPage extends StatefulWidget {
  final String title;
  final String? userId;

  const CustomersListPage({
    super.key,
    required this.title,
    this.userId,
  });

  @override
  State<CustomersListPage> createState() =>
      _CustomersListPageState();
}

class _CustomersListPageState
    extends State<CustomersListPage> {
  int? status;
  bool isSearch = false;
  final searchC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          if (isSearch) {
            setState(() {
              isSearch = !isSearch;
            });
          }
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          floatingActionButton: Visibility(
            visible:
                widget.userId == null ||
                widget.userId == AuthService().userId,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CreateCustomerAlert();
                  },
                );
              },
              backgroundColor:
                  theme.lightModeColor.prColor300,
              child: Icon(
                color: Colors.white,
                Icons.person_add_alt,
              ),
            ),
          ),
          body: Stack(
            children: [
              Column(
                spacing: 0,
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
                            Icons
                                .arrow_back_ios_new_rounded,
                          ),
                        ),
                        Text(
                          style: TextStyle(
                            fontSize: theme
                                .mobileTexts
                                .h4
                                .fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          widget.title,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isSearch = true;
                              status = null;
                              searchC.clear();
                            });
                          },
                          icon: Icon(
                            size: 20,
                            Icons.search,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 2,
                    ),
                    child: Row(
                      children: [
                        TopSortButtonWidget(
                          status: status,
                          myIndex: null,
                          title: 'All',
                          action: () {
                            setState(() {
                              status = null;
                            });
                          },
                        ),
                        TopSortButtonWidget(
                          status: status,
                          myIndex: 1,
                          title: 'New',
                          action: () {
                            setState(() {
                              status = 1;
                            });
                          },
                        ),
                        TopSortButtonWidget(
                          status: status,
                          myIndex: 2,
                          title: 'Processing',
                          action: () {
                            setState(() {
                              status = 2;
                            });
                          },
                        ),
                        TopSortButtonWidget(
                          status: status,
                          myIndex: 3,
                          title: 'Complete',
                          action: () {
                            setState(() {
                              status = 3;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isSearch,
                    child: SizedBox(height: 15),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20.0,
                        10,
                        20,
                        10,
                      ),
                      child: Builder(
                        builder: (context) {
                          if (returnCustomerProvider(
                                context: context,
                              )
                              .getUsersCustomers(
                                userId: widget.userId,
                                status: status,
                              )
                              .where(
                                (cust) =>
                                    cust.name
                                        .toLowerCase()
                                        .contains(
                                          searchC.text
                                              .toLowerCase(),
                                        ) ||
                                    cust.phone.contains(
                                      searchC.text,
                                    ),
                              )
                              .isEmpty) {
                            return Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text('No Customers Found'),
                                SizedBox(height: 100),
                              ],
                            );
                          } else {
                            return RefreshIndicator(
                              onRefresh: () {
                                return returnCustomerProvider()
                                    .getCustomers();
                              },
                              backgroundColor: Colors.white,
                              color: theme
                                  .lightModeColor
                                  .secColor200,
                              displacement: 10,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(
                                      bottom: 50.0,
                                    ),
                                child: ListView(
                                  children: returnCustomerProvider(context: context)
                                      .getUsersCustomers(
                                        userId:
                                            widget.userId,
                                        status: status,
                                      )
                                      .where(
                                        (cust) =>
                                            cust.name
                                                .toLowerCase()
                                                .contains(
                                                  searchC
                                                      .text
                                                      .toLowerCase(),
                                                ) ||
                                            cust.phone
                                                .contains(
                                                  searchC
                                                      .text,
                                                ),
                                      )
                                      .map(
                                        (cust) => Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                vertical:
                                                    5.0,
                                              ),
                                          child: Ink(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    3,
                                                  ),
                                              color: Colors
                                                  .white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      const Color.fromARGB(
                                                        10,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                  spreadRadius:
                                                      5,
                                                  blurRadius:
                                                      10,
                                                ),
                                              ],
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) {
                                                          return CustomerDetails(
                                                            customer: cust,
                                                          );
                                                        },
                                                  ),
                                                ).then((_) {
                                                  setState(() {
                                                    isSearch =
                                                        false;
                                                    searchC
                                                        .clear();
                                                  });
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      20,
                                                  vertical:
                                                      25,
                                                ),

                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  spacing:
                                                      5,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        spacing:
                                                            10,
                                                        children: [
                                                          Icon(
                                                            size: 16,
                                                            color: Colors.grey,
                                                            Icons.person,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              style: TextStyle(
                                                                fontSize: theme.mobileTexts.b1.fontSize,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              cust.name,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      spacing:
                                                          5,
                                                      children: [
                                                        Text(
                                                          style: TextStyle(
                                                            fontSize: theme.mobileTexts.b3.fontSize,
                                                            fontWeight: FontWeight.normal,
                                                            color: theme.lightModeColor.secColor100,
                                                          ),
                                                          formatDateTimeTime(
                                                            returnCommentProvider()
                                                                    .getCustomersComments(
                                                                      cust.uuid!,
                                                                    )
                                                                    .isNotEmpty
                                                                ? returnCommentProvider()
                                                                      .getCustomersComments(
                                                                        cust.uuid!,
                                                                      )
                                                                      .first
                                                                      .createdAt
                                                                : cust.lastComment,
                                                          ),
                                                        ),
                                                        Icon(
                                                          size: 18,
                                                          Icons.arrow_forward_ios_rounded,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  // SizedBox(height: 50),
                ],
              ),
              Visibility(
                visible: isSearch,
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus
                        ?.unfocus();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      20,
                      5,
                      20,
                      0,
                    ),
                    padding: EdgeInsets.fromLTRB(
                      20,
                      5,
                      20,
                      20,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: 400,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            24,
                            0,
                            0,
                            0,
                          ),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          spacing: 5,
                          children: [
                            Opacity(
                              opacity: 0,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  size: 22,
                                  color:
                                      Colors.grey.shade700,
                                  Icons.clear,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: theme
                                      .mobileTexts
                                      .h4
                                      .fontSize,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                                'Search Customer',
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isSearch = false;
                                  searchC.clear();
                                });
                              },
                              icon: Icon(
                                size: 22,
                                color: Colors.grey.shade700,
                                Icons.clear,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 2),
                        GeneralTextfieldOnly(
                          hint: 'Enter Phone/Name',
                          controller: searchC,
                          lines: 1,
                          theme: theme,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopSortButtonWidget extends StatelessWidget {
  const TopSortButtonWidget({
    super.key,
    required this.status,
    required this.title,
    required this.myIndex,
    required this.action,
  });

  final int? status;
  final String title;
  final int? myIndex;
  final Function()? action;

  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return Expanded(
      child: InkWell(
        onTap: action,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: status == myIndex
                    ? theme.lightModeColor.prColor250
                    : Colors.transparent,
                width: status == myIndex ? 1 : 0,
              ),
            ),
          ),
          padding: EdgeInsetsGeometry.all(8),
          child: Center(
            child: Text(
              style: TextStyle(
                fontSize: theme.mobileTexts.b4.fontSize,
                fontWeight: status == myIndex
                    ? FontWeight.bold
                    : null,
              ),
              title,
            ),
          ),
        ),
      ),
    );
  }
}
