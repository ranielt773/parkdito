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
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 12),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Search button
              Image.asset(
                "assets/search.png",
                width: 40,
                height: 40,
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
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0), // Added margin on both sides
        child: Column(
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

            const SizedBox(height: 20), // Added some spacing

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
                padding: const EdgeInsets.all(15),
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
                    floor: booking["floor"]?.toString() ?? "Unknown Floor", // Extract floor from booking data
                  );
                },
              ),
            ),
          ],
        ),
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
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3B060A) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
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

  // Booking Card Widget (Modified Design)
  Widget bookingCard({
    required String status,
    required String title,
    required String location,
    required String slot,
    required String date,
    required String remainingTime,
    required String imageUrl,
    required String floor, // Added floor parameter
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      color: const Color(0xFFFFF9EC),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Status
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                decoration: BoxDecoration(

                  border: Border.all(color: const Color(0xFF3B060A), width: 2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                  "http://192.168.68.65/parkditto_api/imgicon.png",
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(
                  height: 150,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Image.asset(
                      "assets/imgicon.png",
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ),

              // Status Badge
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status[0].toUpperCase() + status.substring(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3B060A),
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Single row with title/location on left and slot/view on right
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Location (left side)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 8,right: 5), // Margin on the right side
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3B060A),
                              ),
                            ),
                            Text(
                              location,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              date,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3B060A),
                                fontSize: 15,
                              ),
                            ),
                            // Display floor information
                            
                          ],
                        ),
                      ),
                    ),

                    // Slot and View button (right side in a column)
                    Container(
                      margin: const EdgeInsets.only(right: 8), // Margin on the left side
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Slot number
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFFFDF7D8),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              slot,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3B060A),
                              ),
                            ),
                          ),

                          // View Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3B060A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: const Size(60, 30),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingStatusPage(
                                    parkingName: title,
                                    location: location,
                                    slotNumber: slot,
                                    dateRange: date,
                                    remainingTime: remainingTime,
                                    floor: floor, // Pass floor to BookingStatusPage
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "View",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}