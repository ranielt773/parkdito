import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:parkditto/api/api_service.dart';
import 'package:parkditto/pages/booking_contents/booking_status.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  String selectedTab = "All";
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadUserDataAndBookings();
  }

  Future<void> _loadUserDataAndBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('userData');

      if (userDataString != null) {
        final userData = jsonDecode(userDataString);
        setState(() {
          userId = userData['id'];
        });

        await _fetchBookings();
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchBookings() async {
    try {
      if (userId == null) return;

      final bookingsData = await ApiService.getUserBookings(userId!);
      setState(() {
        bookings = List<Map<String, dynamic>>.from(bookingsData);
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching bookings: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter bookings based on tab
    List<Map<String, dynamic>> filteredBookings = selectedTab == "All"
        ? bookings
        : bookings.where((b) => b["status"]?.toString().toLowerCase() == selectedTab.toLowerCase()).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Search button
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {},
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B060A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),

              // Title
              const Text(
                "Booking",
                style: TextStyle(
                  color: Color(0xFF3B060A),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              // Bell button
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {},
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B060A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                bookingTab("All"),
                bookingTab("pending"),
                bookingTab("ongoing"),
                bookingTab("cancelled"),
                bookingTab("completed"),
              ],
            ),
          ),

          // Booking List
          Expanded(
            child: filteredBookings.isEmpty
                ? const Center(
              child: Text(
                "No bookings available",
                style: TextStyle(color: Colors.black54, fontSize: 16),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                final booking = filteredBookings[index];
                return bookingCard(
                  status: booking["status"]?.toString() ?? "pending",
                  title: booking["title"]?.toString() ?? "Unknown Parking",
                  location: booking["location"]?.toString() ?? "Unknown Location",
                  slot: booking["slot"]?.toString() ?? "Slot Unknown",
                  date: booking["formatted_date"]?.toString() ?? "No date",
                  remainingTime: booking["remaining_time"]?.toString() ?? "No time",
                  imageUrl: booking["image_url"]?.toString() ?? "",
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Booking Tab Widget (Clickable)
  Widget bookingTab(String text) {
    bool isActive = selectedTab == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = text;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3B060A) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Booking Card Widget
  Widget bookingCard({
    required String status,
    required String title,
    required String location,
    required String slot,
    required String date,
    required String remainingTime,
    required String imageUrl,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 2,
      color: const Color(0xFFFEFBEC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF3B060A), width: 2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                    "http://192.168.68.73/$imageUrl", // Update with your server IP
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      width: double.infinity,
                      child: Center(
                        child: Image.asset(
                          "assets/imgicon.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                      : Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: Center(
                      child: Image.asset(
                        "assets/imgicon.png",
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B060A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                     color:  Color(0xFF3B060A),
                  ),
                ),
                Text(location, style: const TextStyle(color: Color(0xFF3B060A))),
                const SizedBox(height: 8),

                // Date + Slot
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B060A),
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF7D8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        slot,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // View Button
                Align(
                  alignment: Alignment.centerRight,
                  child: Builder(
                    builder: (buttonContext) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B060A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          buttonContext,
                          MaterialPageRoute(
                            builder: (context) => BookingStatusPage(
                              parkingName: title,
                              location: location,
                              slotNumber: slot,
                              dateRange: date,
                              remainingTime: remainingTime,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "View",
                        style: TextStyle(color: Colors.white),
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
}