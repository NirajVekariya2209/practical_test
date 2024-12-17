import 'package:flutter/material.dart';
import 'package:practical_test/presentation/screens/Signature_screen.dart';
import 'package:practical_test/presentation/screens/home_screen.dart';
import 'package:practical_test/presentation/screens/order_details_screen.dart';

class RouteNames{
  static const String signatureScreen = '/signatureScreen';
  static const String orderDetailScreen = '/orderDetailScreen';
  static const String homeScreen = '/homeScreen';
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.homeScreen:
        return MaterialPageRoute(
          builder: (_) => const MyHomeScreen(),
        );
      case RouteNames.signatureScreen:
        return MaterialPageRoute(
          builder: (_) => const SignatureScreen(),
        );
      case RouteNames.orderDetailScreen:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(allItemsList: args['itemsList'] ?? [],),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page Not Found')),
          ),
        );
    }
  }
}

