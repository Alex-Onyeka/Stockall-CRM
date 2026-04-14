import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stockallcrm/pages/authentication/base_page.dart';
import 'package:stockallcrm/providers/comment_provider.dart';
import 'package:stockallcrm/providers/customer_provider.dart';
import 'package:stockallcrm/providers/theme_provider.dart';
import 'package:stockallcrm/providers/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: true,
      statusBarBrightness: Brightness.light,
    ),
  );
  // Lock to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Supabase.initialize(
    url: 'https://ddyhksawkkdbgkllkaxv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRkeWhrc2F3a2tkYmdrbGxrYXh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU2Mjk4OTYsImV4cCI6MjA5MTIwNTg5Nn0.oaqnSvDYMZ0NtbtdXO1a-X2hCunpJTGSyLKAU3mgxG4',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CommentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CustomerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

CustomerProvider returnCustomerProvider({
  BuildContext? context,
}) {
  if (context == null) {
    return CustomerProvider();
  } else {
    return Provider.of<CustomerProvider>(context);
  }
}

ThemeProvider returnThemeProvider({BuildContext? context}) {
  if (context == null) {
    return ThemeProvider();
  } else {
    return Provider.of<ThemeProvider>(context);
  }
}

UserProvider returnUserProvider({BuildContext? context}) {
  if (context == null) {
    return UserProvider();
  } else {
    return Provider.of<UserProvider>(context);
  }
}

CommentProvider returnCommentProvider({
  BuildContext? context,
}) {
  if (context == null) {
    return CommentProvider();
  } else {
    return Provider.of<CommentProvider>(context);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockall CRM',
      initialRoute: "/",
      routes: {'/': (context) => BasePage()},
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemStatusBarContrastEnforced: true,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          toolbarHeight: 80,
        ),
        scaffoldBackgroundColor: Colors.white,
        // fontFamily: 'Plus Jakarta Sans',
        primaryColor: const Color.fromRGBO(25, 43, 117, 1),
      ),
    );
  }
}
