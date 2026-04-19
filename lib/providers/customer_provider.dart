import 'package:flutter/material.dart';
import 'package:stockallcrm/classes/comment_class.dart';
import 'package:stockallcrm/classes/customers_class.dart';
import 'package:stockallcrm/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerProvider extends ChangeNotifier {
  static final CustomerProvider _instance =
      CustomerProvider._internal();
  factory CustomerProvider() => _instance;
  CustomerProvider._internal();

  SupabaseClient supabase = Supabase.instance.client;

  final String tableName = 'customers';

  List<CustomerClass> customers = [];

  void clearAll() {
    customers.clear();
    print('All Customers Cleared');
    notifyListeners();
  }

  int? tempBatch;

  void selectTempBatch(int? index) {
    tempBatch = index;
    notifyListeners();
  }

  int? currentBatch;

  void selectBatch(int? index) {
    currentBatch = index;
    notifyListeners();
  }

  String currentBatchText() {
    return currentBatch != null
        ? "Batch $currentBatch"
        : "All Batches";
  }

  List<CustomerClass> getUsersCustomers({
    String? userId,
    int? status,
  }) {
    customers.sort(
      (a, b) => b.lastComment.compareTo(a.lastComment),
    );
    if (currentBatch == null) {
      return status != null
          ? userId == null
                ? customers
                      .where(
                        (cust) => cust.status == status,
                      )
                      .toList()
                : customers
                      .where(
                        (cust) =>
                            cust.userId == userId &&
                            cust.status == status,
                      )
                      .toList()
          : userId == null
          ? customers
          : customers
                .where((cust) => cust.userId == userId)
                .toList();
    } else {
      return status != null
          ? userId == null
                ? customers
                      .where(
                        (cust) =>
                            cust.status == status &&
                            cust.batch == currentBatch,
                      )
                      .toList()
                : customers
                      .where(
                        (cust) =>
                            cust.userId == userId &&
                            cust.status == status &&
                            cust.batch == currentBatch,
                      )
                      .toList()
          : userId == null
          ? customers
                .where((cust) => cust.batch == currentBatch)
                .toList()
          : customers
                .where(
                  (cust) =>
                      cust.userId == userId &&
                      cust.batch == currentBatch,
                )
                .toList();
    }
  }

  Future<int> getCustomers() async {
    try {
      var res = await supabase.from(tableName).select();
      print('Customers Gotten: ${res.length}');
      customers = res
          .map((re) => CustomerClass.fromJson(re))
          .toList();
      notifyListeners();
      return 1;
    } catch (e) {
      print('Error Getting Customers: ${e.toString()}');
      return 0;
    }
  }

  Future<int> createCustomer({
    required CustomerClass customer,
    CommentClass? comment,
  }) async {
    try {
      var res = await supabase
          .from(tableName)
          .insert(customer.toJson())
          .select()
          .maybeSingle();
      if (res == null) {
        print('Error Creating Customer');
        return 0;
      }
      customers.add(CustomerClass.fromJson(res));
      if (comment != null) {
        comment.customerId = res['uuid'];
        await returnCommentProvider().createComment(
          comment,
        );
      }
      notifyListeners();
      return 1;
    } catch (e) {
      print('Error Creating Customer: ${e.toString()}');
      return 0;
    }
  }

  Future<int> updateCustomer({
    required CustomerClass customer,
  }) async {
    try {
      var res = await supabase
          .from(tableName)
          .update(customer.toJson())
          .eq('uuid', customer.uuid!)
          .select()
          .maybeSingle();
      if (res == null) {
        print('Error Updating Customer');
        return 0;
      }
      try {
        var cus = customers.firstWhere(
          (cust) => cust.uuid == customer.uuid,
        );
        cus = customer;
        print(cus.name);
      } catch (e) {
        print(
          'Error Updating Customer Cache: ${e.toString()}',
        );
      }
      notifyListeners();
      return 1;
    } catch (e) {
      print('Error Updating Customer: ${e.toString()}');
      return 0;
    }
  }

  Future<int> deleteCustomer(String uuid) async {
    try {
      var res = await supabase
          .from(tableName)
          .delete()
          .eq('uuid', uuid)
          .select()
          .maybeSingle();

      if (res == null) {
        print('Customer Deletion Failed');
        return 0;
      }
      customers.removeWhere((cust) => cust.uuid == uuid);
      notifyListeners();
      return 1;
    } catch (e) {
      print('Error Deleting Customer: ${e.toString()}');
      return 0;
    }
  }
}
