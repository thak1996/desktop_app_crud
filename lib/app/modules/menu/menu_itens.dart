import 'package:desktop_app_crud/app/modules/menu/pages/accounts.page.dart';
import 'package:flutter/material.dart';
import 'menu_details.dart';
import 'pages/dashboard.page.dart';
import 'pages/notifications.page.dart';
import 'pages/reports.page.dart';
import 'pages/settings.page.dart';

class MenuItens {
  List<MenuDetails> items = [
    MenuDetails(
      title: "DashBoard",
      icon: Icons.dashboard,
      page: DashboardPage(),
    ),
    MenuDetails(
      title: "Accounts",
      icon: Icons.account_circle_rounded,
      page: AccountsPage(),
    ),
    MenuDetails(
      title: "Notifications",
      icon: Icons.notification_important_rounded,
      page: NotificationsPage(),
    ),
    MenuDetails(title: "Reports", icon: Icons.add_chart, page: ReportsPage()),
    MenuDetails(title: "Settings", icon: Icons.settings, page: SettingsPage()),
  ];
}
