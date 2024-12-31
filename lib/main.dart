import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing/view/home_screen.dart';
import 'package:testing/view_model/home_screen_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GraphQL App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider<HomeScreenViewModel>(
        create: (_) => HomeScreenViewModel()..getCategoriesData(),
        builder: (context, child) => const HomeScreen(),
      ),
    );
  }
}
