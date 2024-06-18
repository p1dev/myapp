import 'package:flutter/material.dart';
import 'package:myapp/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://kvfpraaawgqhgbnkvfug.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt2ZnByYWFhd2dxaGdibmt2ZnVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTc3MzA0NzMsImV4cCI6MjAzMzMwNjQ3M30.iKwsgBfSxcXLpv0uXUvgKqxrz3KBQ1wkLOt9eijRLrQ', 
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Viajes App',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: LoginPage()
    );
  }
}