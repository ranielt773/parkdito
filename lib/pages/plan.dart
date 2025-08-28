import 'package:flutter/material.dart';
import 'package:parkditto/pages/booking_contents/booking_status.dart';

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  String selectedTab = "All";

  // Mock data for prototype
  final List<Map<String, String>> bookings = [
    {
      "status": "Reserved",
      "title": "Farmlane Parking",
      "location": "Bae Laguna near Jollibee",
      "slot": "Slot 4",
      "date": "April 25 - May 25",
    },
    {
      "status": "Ongoing",
      "title": "City Mall Parking",
      "location": "Sta. Rosa Laguna",
      "slot": "Slot 12",
      "date": "May 1 - May 3",
    },
    {
      "status": "Canceled",
      "title": "Festival Mall Parking",
      "location": "Alabang",
      "slot": "Slot 7",
      "date": "May 10 - May 12",
    },
    {
      "status": "Ongoing",
      "title": "SM Parking",
      "location": "Calamba",
      "slot": "Slot 2",
      "date": "May 15 - May 20",
    },
    {
      "status": "Reserved",
      "title": "Ayala Parking",
      "location": "Makati",
      "slot": "Slot 5",
      "date": "June 1 - June 5",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter bookings based on tab
    List<Map<String, String>> filteredBookings =
        selectedTab == "All"
            ? bookings
            : bookings.where((b) => b["status"] == selectedTab).toList();

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

      body: Column(
        children: [
          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                bookingTab("All"),
                bookingTab("Reserved"),
                bookingTab("Ongoing"),
                bookingTab("Canceled"),
              ],
            ),
          ),

          // Booking List
          Expanded(
            child:
                filteredBookings.isEmpty
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
                          status: booking["status"]!,
                          title: booking["title"]!,
                          location: booking["location"]!,
                          slot: booking["slot"]!,
                          date: booking["date"]!,
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
                  child: Image.asset(
                    "assets/farmlae_parking.png",
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(location, style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 8),

                // Date + Slot
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
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

                const SizedBox(height: 10),

                // View Button
                Align(
                  alignment: Alignment.centerRight,
                  child: Builder(
                    builder:
                        (buttonContext) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B060A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              buttonContext,
                              MaterialPageRoute(
                                builder:
                                    (context) => BookingStatusPage(
                                      parkingName: title,
                                      location: location,
                                      slotNumber: slot,
                                      dateRange: date,
                                      remainingTime:
                                          "15 days 5 hours 12 mins 48 secs",
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
