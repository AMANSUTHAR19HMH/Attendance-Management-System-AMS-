import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class navbar_top extends StatelessWidget {
  const navbar_top({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
                accountName: Text("JackWilliam"),
                accountEmail: Text("Jackwilliam456@gmail.com")),

            // Nav bar Title and Icons //
            ListTile(
              leading: const Icon(CommunityMaterialIcons.view_dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pushNamed(context, '/Dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text("Attendance"),
              onTap: () {
                Navigator.pushNamed(context, '/Attendance');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.logout_sharp),
              title: const Text("Logout"),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
