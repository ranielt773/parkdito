import 'package:flutter/material.dart';
import 'profile/details.dart';
import 'profile/password.dart';
import 'profile/plan.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Function to handle navigation to Personal Details page
  void _navigateToPersonalDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PersonalDetailsPage()),
    );
  }

  // Function to handle navigation to Change Password page
  void _navigateToChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
    );
  }

  void _navigateToMyPlan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyPlanPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Image.asset(
                "assets/back.png",
                width: 40,
                height: 40,
              ),
            ),
            Column(
              children: [
                const Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B060A),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 40, // keeps balance with back button width
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          // Profile Picture with border
          Center(
            child: Container(
              child: const CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage(
                  "lib/assets/logo.png",
                ), // Replace with your image
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Options List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              children: [
                buildMenuItem(
                  "Personal Details",
                  onTap: () {
                    _navigateToPersonalDetails(context);
                  },
                ),
                buildMenuItem(
                  "Plan Status",
                  onTap: () {
                    _navigateToMyPlan(context);
                  },
                ),
                buildMenuItem(
                  "Change Password",
                  onTap: () {
                    _navigateToChangePassword(context);
                  },
                ),
                buildMenuItem("Settings", onTap: () {}),
                const SizedBox(height: 30),

                // Sign Out Button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Sign out",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C0B0B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 3,
                      ),

                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Updated menu item widget with onTap parameter
  Widget buildMenuItem(String title, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        padding: const EdgeInsets.only(left: 50, right: 10),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4C0B0B),
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFF4C0B0B),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
