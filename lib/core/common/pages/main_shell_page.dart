import 'package:ajudafio_mobile/core/common/widgets/main_bottom_nav_bar.dart';
import 'package:ajudafio_mobile/features/home/presentation/pages/home_page.dart';
import 'package:ajudafio_mobile/features/professional_list/presentation/pages/professtional_list_page.dart';
import 'package:flutter/material.dart';

/// Fixed bottom-nav shell composing the app's top-level feature pages.
///
/// Uses [IndexedStack] instead of [Navigator.push] so switching tabs keeps
/// each page's state alive (scroll position, in-progress filters, etc.)
/// instead of rebuilding from scratch. Tabs don't need the session token or
/// user data passed to them: `AppUserCubit` already holds that globally and
/// `AuthenticatedHttpClient` already refreshes the token transparently for
/// whichever tab makes a request.
class MainShellPage extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute(builder: (context) => const MainShellPage());

  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;

  static const _pages = [HomePage(), ProfesstionalListPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
