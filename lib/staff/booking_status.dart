import 'package:flutter/material.dart';

class BookingStatusPage extends StatefulWidget {
  final String parkingName;
  final String location;
  final String slotNumber;
  final String dateRange;
  final String remainingTime;
  final String floor;
  final String planName;
  final String planPrice;
  final Color planColor;
  final Color textColor;

  const BookingStatusPage({
    super.key,
    this.parkingName = "Default Parking",
    this.location = "Default Location",
    this.slotNumber = "--",
    this.dateRange = "No date selected",
    this.remainingTime = "--",
    this.floor = "Unknown Floor",
    this.planName = "Monthly",
    this.planPrice= "2500",
    this.planColor= Colors.black38,
    this.textColor= Colors.white,
  });

  @override
  State<BookingStatusPage> createState() => _BookingStatusPageState();
}

class _BookingStatusPageState extends State<BookingStatusPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF3B060A)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Slot 2",
            style: TextStyle(
              color: Color(0xFF3B060A),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF3B060A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Monthly Plan Card
            _PlanCard(
              title: "Monthly Plan",
              price: "2500/month",
              renewalDate: "Renews on May 25, 2025",
              perks: const [
                {"icon": Icons.videocam, "label": "CCTV"},
                {"icon": Icons.person, "label": "Caretaker"},
                {"icon": Icons.verified, "label": "Insurance"},
                {"icon": Icons.local_car_wash, "label": "Carwash"},
              ],
              active: true,
              showProgress: false,
            ),

            const SizedBox(height: 20),

            /// Remaining Time Section
            Column(
              children: [
                const Text(
                  "Remaining time",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF3B060A),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: const [
                      Text(
                        "April 25 → May 25",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "15 days 5 hours 12 mins 48 secs",
                        style: TextStyle(color: Color(0xFF3B060A)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("End"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Storm Pass Card
            _PlanCard(
              title: "Storm pass",
              price: "2500/month",
              renewalDate: "Renews on Aug 23, 2025",
              perks: const [],
              active: true,
              showProgress: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String renewalDate;
  final List<Map<String, dynamic>> perks;
  final bool active;
  final bool showProgress;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.renewalDate,
    required this.perks,
    required this.active,
    required this.showProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF7D8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + Active badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF3B060A))),
              if (active)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B060A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Active",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          /// Price
          Text(
            price,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF3B060A),
            ),
          ),

          const SizedBox(height: 12),

          /// Perks Row
          if (perks.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: perks
                  .map(
                    (perk) => Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B060A),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(perk["icon"],
                          size: 20, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(perk["label"],
                        style: const TextStyle(color: Color(0xFF3B060A))),
                  ],
                ),
              )
                  .toList(),
            ),

          if (perks.isNotEmpty) const SizedBox(height: 12),

          /// Renewal date
          Text(
            renewalDate,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF3B060A),
            ),
          ),

          /// Progress bar for Storm pass
          if (showProgress) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.4, // sample progress
              backgroundColor: Colors.grey.shade300,
              color: Colors.red,
              minHeight: 4,
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ],
      ),
    );
  }
}