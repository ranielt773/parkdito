import 'package:flutter/material.dart';

class MyPlanPage extends StatelessWidget {
  const MyPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button + Title
              Row(
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
                        "My Plan",
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

              const SizedBox(height: 20),

              const Text(
                "Manage and view your current subscription",
                style: TextStyle(fontSize: 16, color: Color(0xFF4C0B0B)),
              ),
              const SizedBox(height: 16),

              // Container that wraps both subscription cards
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF7D8).withOpacity(0.53),
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // New container background
                ),
                child: Column(
                  children: [
                    // Monthly Plan Card (without action button)
                    _buildSubscriptionCard(
                      title: "Monthly Plan",
                      price: "2500/month",
                      renewalDate: "Renews on Aug 26, 2025",
                      perks: const [
                        {"icon": Icons.videocam, "label": "CCTV"},
                        {"icon": Icons.person, "label": "Caretaker"},
                        {"icon": Icons.security, "label": "Insurance"},
                        {"icon": Icons.local_car_wash, "label": "Carwash"},
                      ],
                    ),

                    // Upgrade Plan Button (under Monthly Plan) - Smaller and Right Aligned
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              237,
                              0,
                              52,
                              27,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 15,
                            ), // Smaller padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(
                              0,
                              40,
                            ), // Smaller minimum size
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Upgrade plan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14, // Smaller font size
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Storm Pass Card (without action button)
                    _buildSubscriptionCard(
                      title: "Storm pass",
                      price: "2500/month",
                      renewalDate: "Renews on Aug 23, 2025",
                      perks: const [],
                    ),

                    // Extend Pass Button (under Storm Pass) - Smaller and Right Aligned
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              237,
                              0,
                              52,
                              27,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 60,
                              vertical: 15,
                            ), // Smaller padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(
                              0,
                              40,
                            ), // Smaller minimum size
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Extend pass",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14, // Smaller font size
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required String title,
    required String price,
    required String renewalDate,
    required List<Map<String, dynamic>> perks,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromARGB(9, 76, 11, 11), // Card background
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Active badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4C0B0B),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4C0B0B),
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

          // Price
          Center(
            child: Text(
              price,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C0B0B),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Perks icons
          if (perks.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Perks Included",
                  style: TextStyle(fontSize: 12, color: Color(0xFF4C0B0B)),
                ),
                const SizedBox(height: 8),

                // Centered icons row
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        perks
                            .map(
                              (perk) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Column(
                                  children: [
                                    // Square container with rounded corners
                                    Container(
                                      width: 40, // Square size
                                      height: 40, // Square size
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4C0B0B),
                                        borderRadius: BorderRadius.circular(
                                          15,
                                        ), // Rounded corners
                                      ),
                                      child: Icon(
                                        perk["icon"],
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      perk["label"],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4C0B0B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Renewal info
          Text(
            renewalDate,
            style: const TextStyle(fontSize: 16, color: Color(0xFF4C0B0B)),
          ),
          const SizedBox(height: 8),

          // Progress bar (dummy)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF4C0B0B),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
