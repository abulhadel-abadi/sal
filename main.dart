import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const LaptopStoreApp());
}

class LaptopStoreApp extends StatelessWidget {
  const LaptopStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'متجر لابتوبات',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        fontFamily: 'Cairo',
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),

      // home: const ProfileScreen(),
      // home: const ProductsScreen(),
      //home: const CartScreen(),
      // home: const OrdersScreen(),
      // home: const ProductDetailScreen(),
    );
  }
}
