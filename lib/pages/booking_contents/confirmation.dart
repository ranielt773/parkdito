import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button + Title
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
                        "Booking Confirmed",
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

              // QR Code Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  "assets/qr_icon.png", // replace with your QR asset path
                  height: 180,
                  width: 180,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                "Note: Use this code to enter in a parking lot",
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Details Section
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ), // Add left and right margin
                child: Column(
                  children: [
                    // Special case for Details with bold title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Details",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold, // Bold for Details
                            ),
                          ),
                          const Text(
                            "1:13 pm   14/08/2025",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3B060A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    detailRow("Amount received", "₱2500"),
                    detailRow("Plan duration", "Month"),
                    detailRow("Storm pass", "None"),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Ref No.", style: TextStyle(fontSize: 15)),
                        Text("7463164871236", style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Share on Messenger (Tappable)
              GestureDetector(
                onTap: () {
                  // TODO: add your messenger share logic
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/messenger_icon.png", // Messenger icon
                      height: 20,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Share on messenger",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Download + Done Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFBF0000),
                          foregroundColor: Color(0xFFFDF7D8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Download logic
                        },
                        child: const Text(
                          "Download",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF02542D),
                          foregroundColor: Color(0xFFFDF7D8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Done logic
                        },
                        child: const Text(
                          "Done",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget function for rows (no changes needed)
  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3B060A),
            ),
          ),
        ],
      ),
    );
  }
}
