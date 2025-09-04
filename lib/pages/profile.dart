import 'package:flutter/material.dart';
import 'package:parkditto/api/api_service.dart';
import 'package:parkditto/login.dart';
import 'profile/details.dart';
import 'profile/password.dart';
import 'profile/plan.dart'; // Import your API service

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await ApiService.getUserData();
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  // Function to handle navigation to Personal Details page
  void _navigateToPersonalDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonalDetailsPage(userData: userData)),
    ).then((_) {
      // Reload user data when returning from details page
      _loadUserData();
    });
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

  // Function to handle logout
  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await ApiService.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
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
            const SizedBox(
              width: 40, // keeps balance with back button width
            ),
            Column(
              children: [
                const Text(
                  "User Profile",
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: <Widget>[
          const SizedBox(height: 20),
          // Profile Picture with circular container
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFF3B060A).withOpacity(0.3),
                width: 2,
              ),
              color: Colors.white,
            ),
            child: ClipOval(
              child: Image.asset(
                "assets/display.png",
                fit: BoxFit.cover,
                width: 45,
                height: 45,
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Display username if available
          if (userData != null && userData!['username'] != null)
            Text(
              userData!['username'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B060A),
              ),
            ),
          const SizedBox(height: 20),

          // Options List
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFDF7D8).withOpacity(0.53),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                      onPressed: _handleLogout,
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
          ),
        ],
      ),
    );
  }

  // Updated menu item widget with onTap parameter
  Widget buildMenuItem(String title, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      elevation: 0,
      color: Color(0xFF3B060A).withOpacity(0.04),
      child: Container(
        padding: const EdgeInsets.only(left: 50, right: 10),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF3B060A),
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFF3B060A),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}