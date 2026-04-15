//

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

DateTime endOfDay(DateTime date) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    23,
    59,
    59,
    999,
  );
}

DateTime startOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String formatDateTime(DateTime date) {
  return DateFormat('MMM d, yyyy').format(date);
}

String formatDateWithoutYear(DateTime date) {
  return DateFormat('E, MMM d').format(date);
}

String formatMonthAndDay(DateTime date) {
  return DateFormat('MMM d').format(date);
}

String formatDateTimeTime(DateTime date) {
  return DateFormat('E, d : hh:mm a').format(date);
}

String formatDateWithDay(DateTime date) {
  return DateFormat('E, MMM d, yyyy').format(date);
}

String formatTime(DateTime date) {
  return DateFormat('hh:mm a').format(date);
}

String cutLongText({
  required String text,
  required int length,
}) {
  if (text.length > length) {
    return '${text.substring(0, length)}...';
  }
  return text;
}

bool checkValidEmail(String email) {
  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
    return false;
  } else {
    return true;
  }
}

void phoneCall({required String number}) async {
  print(number);
  final Uri uri = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    print('Could not launch $number');
  }
}

void openWhatsApp({required String number}) async {
  final phone = '234${number.substring(1)}'; // your number
  // final message = Uri.encodeComponent(
  //   "Hello, Stockall Solutions; ",
  // );
  final url = 'https://wa.me/$phone';

  await launchUrlMain(url);
}

Future<void> launchUrlMain(url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } else {
    print('Could not launch $url');
  }
}
