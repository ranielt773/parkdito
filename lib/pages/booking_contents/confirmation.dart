import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkditto/mainpage.dart';

class ConfirmationPage extends StatelessWidget {
  final Map<String, dynamic>? transactionData;
  final String? planName;
  final String? planPrice;
  final int? selectedSlot;
  final String? selectedFloor;
  final String? selectedVehicle;

  const ConfirmationPage({
    super.key,
    this.transactionData,
    this.planName,
    this.planPrice,
    this.selectedSlot,
    this.selectedFloor,
    this.selectedVehicle,
    required bool isReservation,
  });

  @override
  Widget build(BuildContext context) {
    // Get data from transaction or use passed parameters
    String refNumber = transactionData?['ref_number']?.toString() ?? "7463164871236";

    // Calculate amount - use transaction amount first, then plan price as fallback
    String amount = "₱2500"; // Default
    if (transactionData != null && transactionData!['amount'] != null) {
      amount = "₱${transactionData!['amount']}";
    } else if (planPrice != null) {
      // Extract numeric value from planPrice (e.g., "2500/m" -> "2500")
      String numericValue = planPrice!.replaceAll(RegExp(r'[^\d]'), '');
      if (numericValue.isNotEmpty) {
        amount = "₱$numericValue";
      }
    }

    // Handle date parsing safely
    String dateTime = "1:13 pm   14/08/2025"; // Default value
    if (transactionData != null && transactionData!['arrival_time'] != null) {
      try {
        final arrivalTime = DateTime.parse(transactionData!['arrival_time']);
        dateTime = "${DateFormat('h:mm a').format(arrivalTime)}   ${DateFormat('dd/MM/yyyy').format(arrivalTime)}";
      } catch (e) {
        // If parsing fails, use current date and time
        final now = DateTime.now();
        dateTime = "${DateFormat('h:mm a').format(now)}   ${DateFormat('dd/MM/yyyy').format(now)}";
      }
    } else {
      // Use current date and time if no transaction data
      final now = DateTime.now();
      dateTime = "${DateFormat('h:mm a').format(now)}   ${DateFormat('dd/MM/yyyy').format(now)}";
    }

    // Determine plan duration based on plan name
    String planDuration = "Month"; // Default
    if (planName != null) {
      if (planName!.toLowerCase().contains("weekly")) {
        planDuration = "Week";
      } else if (planName!.toLowerCase().contains("yearly")) {
        planDuration = "Year";
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: WillPopScope(
        onWillPop: () async {
          // Navigate to main page when back button is pressed
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
                (Route<dynamic> route) => false,
          );
          return false; // Prevent default back behavior
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button + Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 40, // keeps balance with back button width
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
                            Text(
                              dateTime, // Use the safely parsed dateTime
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3B060A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      detailRow("Amount received", amount),
                      detailRow("Plan duration", planDuration),
                      if (selectedSlot != null) detailRow("Slot Number", "Slot $selectedSlot"),
                      if (selectedFloor != null) detailRow("Floor", selectedFloor!),
                      if (selectedVehicle != null) detailRow("Vehicle Type", selectedVehicle!),
                      detailRow("Storm pass", "None"),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Ref No.", style: TextStyle(fontSize: 15)),
                          Text(refNumber, style: const TextStyle(fontSize: 15)), // Use the safe refNumber
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
                            // Navigate to main page (which includes the bottom navigation)
                            // and clear the navigation stack
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => MainPage()),
                                  (Route<dynamic> route) => false,
                            );
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