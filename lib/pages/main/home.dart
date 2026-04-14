import 'package:flutter/material.dart';
import 'package:stockallcrm/components/alerts/confirm_alert.dart';
import 'package:stockallcrm/components/alerts/create_customer.dart';
import 'package:stockallcrm/constants/refresh_function.dart';
import 'package:stockallcrm/main.dart';
import 'package:stockallcrm/pages/main/customers_list_page.dart';
import 'package:stockallcrm/services/auth_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLogOutLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await refreshAll();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return CreateCustomerAlert();
              },
            );
          },
          backgroundColor: theme.lightModeColor.prColor300,
          child: Icon(
            color: Colors.white,
            Icons.person_add_alt,
          ),
        ),
        body: Builder(
          builder: (context) {
            if (returnUserProvider(
              context: context,
            ).users.isEmpty) {
              return Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: theme.lightModeColor.secColor200,
                    strokeWidth: 2,
                  ),
                ),
              );
            } else {
              return Column(
                spacing: 5,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      30,
                      15,
                      15,
                      15,
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
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Icon(size: 18, Icons.person),
                            Text(
                              style: TextStyle(
                                fontSize: theme
                                    .mobileTexts
                                    .b2
                                    .fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              returnUserProvider(
                                    context: context,
                                  ).currentUser()?.name ??
                                  'User Name',
                            ),
                          ],
                        ),
                        Builder(
                          builder: (context) {
                            if (isLogOutLoading) {
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
                                        title: 'Log Out',
                                        message:
                                            'You are about to log out from your account. Are you sure you want to proceed?',
                                        action: () async {
                                          setState(() {
                                            isLogOutLoading =
                                                true;
                                          });
                                          await AuthService()
                                              .signOut(
                                                confirmContext,
                                              );
                                          if (context
                                              .mounted) {
                                            setState(() {
                                              isLogOutLoading =
                                                  false;
                                            });
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: Icon(
                                  size: 20,
                                  color:
                                      Colors.red.shade500,
                                  Icons.logout,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20.0,
                        10,
                        20,
                        10,
                      ),
                      child: RefreshIndicator(
                        onRefresh: () {
                          return refreshAll();
                        },
                        backgroundColor: Colors.white,
                        color: theme
                            .lightModeColor
                            .secColor200,
                        displacement: 10,
                        child: ListView(
                          children: [
                            HomeListTile(
                              title: 'All Customers',
                            ),
                            HomeListTile(
                              title: 'My Customers',
                              userId: AuthService().userId,
                            ),
                            Column(
                              children: returnUserProvider()
                                  .otherUsers()
                                  .map(
                                    (user) => HomeListTile(
                                      title: user.name,
                                      userId: user.uuid,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class HomeListTile extends StatelessWidget {
  final String? userId;
  final String title;

  const HomeListTile({
    super.key,
    this.userId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    var theme = returnThemeProvider();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(10, 0, 0, 0),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CustomersListPage(
                    title: title,
                    userId: userId,
                  );
                },
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 25,
            ),

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              spacing: 5,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Icon(
                      size: 16,
                      color: Colors.grey,
                      Icons.folder_copy_outlined,
                    ),
                    Text(
                      style: TextStyle(
                        fontSize:
                            theme.mobileTexts.b1.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      title,
                    ),
                  ],
                ),
                Row(
                  spacing: 5,
                  children: [
                    Text(
                      style: TextStyle(
                        fontSize:
                            theme.mobileTexts.b2.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      returnCustomerProvider(
                            context: context,
                          )
                          .getUsersCustomers(userId: userId)
                          .length
                          .toString(),
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
    );
  }
}
