import 'package:stockallcrm/main.dart';

Future<void> refreshAll() async {
  await returnUserProvider().fetchAllUsers();
  await returnCustomerProvider().getCustomers();
  await returnCommentProvider().getComments();
}
