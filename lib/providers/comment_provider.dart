import 'package:flutter/material.dart';
import 'package:stockallcrm/classes/comment_class.dart';
import 'package:stockallcrm/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentProvider extends ChangeNotifier {
  static final CommentProvider _instance =
      CommentProvider._internal();
  factory CommentProvider() => _instance;
  CommentProvider._internal();

  SupabaseClient supabase = Supabase.instance.client;

  final String tableName = 'comments';

  List<CommentClass> comments = [];

  void clearAll() {
    comments.clear();
    print('All Comments Cleared');
    notifyListeners();
  }

  List<CommentClass> getCustomersComments(
    String customerUuid,
  ) {
    comments.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );
    return comments
        .where((comt) => comt.customerId == customerUuid)
        .toList();
  }

  Future<int> createComment(CommentClass comment) async {
    try {
      var res = await supabase
          .from(tableName)
          .insert(comment.toJson())
          .select()
          .maybeSingle();
      if (res == null) {
        print('Creating Comment Failed');
        return 0;
      }
      comments.add(CommentClass.fromJson(res));
      notifyListeners();
      await supabase
          .from('customers')
          .update({
            'last_comment': DateTime.now()
                .toIso8601String(),
          })
          .eq('uuid', comment.customerId);
      var cust = returnCustomerProvider().customers
          .firstWhere(
            (cust) => cust.uuid == comment.customerId,
          );
      cust.lastComment = DateTime.now();
      notifyListeners();
      return 1;
    } catch (e) {
      print('Error Creating Comment: ${e.toString()}');
      return 0;
    }
  }

  Future<int> getComments() async {
    try {
      var res = await supabase.from(tableName).select();
      comments = res
          .map((re) => CommentClass.fromJson(re))
          .toList();
      print('Comments Gotten: ${res.length}');
      notifyListeners();
      return 1;
    } catch (e) {
      print('Error Getting Comments: ${e.toString()}');
      return 0;
    }
  }

  Future<int> updateComment(CommentClass comment) async {
    try {
      var res = await supabase
          .from(tableName)
          .upsert(comment.toJson())
          .select()
          .maybeSingle();
      if (res == null) {
        print('Updating Comment Failed');
        return 0;
      }
      // comments.add(CommentClass.fromJson(res));
      var comt = comments.firstWhere(
        (com) => com.uuid == comment.uuid,
      );
      comt.comment = comment.comment;
      notifyListeners();
      await supabase
          .from('customers')
          .update({
            'last_comment': DateTime.now()
                .toIso8601String(),
          })
          .eq('uuid', comment.customerId);
      var cust = returnCustomerProvider().customers
          .firstWhere(
            (cust) => cust.uuid == comment.customerId,
          );
      cust.lastComment = DateTime.now();
      notifyListeners();
      return 1;
    } catch (e) {
      print('Error Updating Comment: ${e.toString()}');
      return 0;
    }
  }

  Future<int> deleteComment(String uuid) async {
    try {
      var res = await supabase
          .from(tableName)
          .delete()
          .eq('uuid', uuid)
          .select()
          .maybeSingle();
      if (res == null) {
        print('Deleing Comment Failed');
        return 0;
      }
      comments.removeWhere((com) => com.uuid == uuid);
      notifyListeners();
      return 1;
    } catch (e) {
      print('Error Deleting Comment: ${e.toString()}');
      return 0;
    }
  }
}
