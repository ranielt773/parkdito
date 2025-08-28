import 'package:flutter/material.dart';
import 'cctv_view.dart';
import 'plan.dart';

class BookingStatusPage extends StatefulWidget {
  final String parkingName;
  final String location;
  final String slotNumber;
  final String dateRange;
  final String remainingTime;

  const BookingStatusPage({
    super.key,
    this.parkingName = "Default Parking",
    this.location = "Default Location",
    this.slotNumber = "--",
    this.dateRange = "No date selected",
    this.remainingTime = "--",
  });

  @override
  State<BookingStatusPage> createState() => _BookingStatusPageState();
}

class _BookingStatusPageState extends State<BookingStatusPage> {
  int selectedIndex = 0; // 👈 track active tab

  final List<String> tabs = ["Ground", "2nd Floor", "3rd Floor"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), // taller app bar
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10, // 👈 add extra top & bottom padding
          ),
          color: Colors.white,
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button (replaces search)
              InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B060A),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 22, // 👈 matches notification icon size
                  ),
                ),
              ),

              // Title
              const Text(
                "Booking Status",
                style: TextStyle(
                  color: Color(0xFF3B060A),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              // Bell button
              InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () {},
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF3B060A),
                    borderRadius: BorderRadius.circular(5),
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
          // 👇 Custom Tabs (replace TabBar)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                tabs.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: bookingTab(tabs[index], selectedIndex == index),
                ),
              ),
            ),
          ),

          // 👇 Tab Content
          Expanded(
            child: Builder(
              builder: (_) {
                if (selectedIndex == 0) {
                  return _buildStatusContent(
                    widget.parkingName,
                    widget.location,
                    widget.slotNumber,
                    widget.dateRange,
                    widget.remainingTime,
                  );
                } else if (selectedIndex == 1) {
                  return _buildStatusContent(
                    "2nd Floor Parking",
                    widget.location,
                    "Slot B12",
                    widget.dateRange,
                    "10 days 8 hours 43 mins 11 secs",
                  );
                } else {
                  return _buildStatusContent(
                    "3rd Floor Parking",
                    widget.location,
                    "Slot C8",
                    widget.dateRange,
                    "5 days 3 hours 49 mins 23 secs",
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Booking Tab Widget
  Widget bookingTab(String text, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
    );
  }

  /// Modified: accepts parameters instead of using [widget] everywhere
  Widget _buildStatusContent(
    String parkingName,
    String location,
    String slotNumber,
    String dateRange,
    String remainingTime,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFFDF7D8),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parking Image Card
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF3B060A),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(5), // not so rounded
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      "assets/farmlae_parking.png",
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Reserved Label
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "Reserved",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B060A),
                      ),
                    ),
                  ),
                ),

                // CCTV Button
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CCTVViewPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image.asset(
                        "assets/cctv_icon.png",
                        height: 24, // adjust size
                        width: 24, // adjust size
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Parking Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parkingName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 4,
                        ), // push location
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Color(0xFF3B060A),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF7D8),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Color(0xFF3B060A)),
                    ),
                    child: Text(
                      "$slotNumber",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B060A),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Date Range
            Center(
              child: Text(
                dateRange,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF3B060A),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Remaining Time
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                constraints: const BoxConstraints(minWidth: 230),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Remaining time",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B060A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      remainingTime,
                      style: const TextStyle(color: Color(0xFF3B060A)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // End & Extend Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120, // set a fixed width (adjust as you like)
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "End",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // gap between buttons
                SizedBox(
                  width: 120, // same width as "End" button
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B060A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // same radius
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlanPage()),
                      );
                    },
                    child: const Text(
                      "Extend",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Perks Included
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF7D8),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + View Plan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Perks Included",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B060A),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PlanPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "View Plan",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Perks row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _PerkItem(
                        imagePath: "assets/cctv_icon.png",
                        label: "CCTV",
                      ),
                      _PerkItem(
                        imagePath: "assets/caretaker_icon.png",
                        label: "Caretaker",
                      ),
                      _PerkItem(
                        imagePath: "assets/insurance_icon.png",
                        label: "Insurance",
                      ),
                      _PerkItem(
                        imagePath: "assets/carwash_icon.png",
                        label: "Carwash",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerkItem extends StatelessWidget {
  final String imagePath;
  final String label;

  const _PerkItem({required this.imagePath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF3B060A),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Image.asset(
            imagePath,
            height: 28,
            width: 28,
            color: Colors.white, // keeps icons white-like
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Color(0xFF3B060A))),
      ],
    );
  }
}
