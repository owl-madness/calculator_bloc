import 'package:calculator_bloc/features/calculator/presentation/bloc/calculator_bloc.dart';
import 'package:calculator_bloc/features/calculator/presentation/pages/calculator_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (context) => CalculatorBloc(),
        child: const CalculatorPage(),
      ),
    );
  }
}
