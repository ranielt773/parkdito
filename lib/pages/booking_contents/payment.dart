import 'package:flutter/material.dart';
import 'confirmation.dart';

class PaymentPage extends StatelessWidget {
  final String planName;
  final String planPrice;
  final Color planColor;
  final Color textColor;

  const PaymentPage({
    super.key,
    required this.planName,
    required this.planPrice,
    required this.planColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        "Payment",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 48, // keeps balance with back button width
                  ),
                ],
              ),


              const SizedBox(height: 25),

              // Selected Plan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF3B060A).withOpacity(.8),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      planName,
                      style: TextStyle(color: textColor, fontSize: 16),
                    ),
                    Text(
                      planPrice,
                      style: TextStyle(color: textColor, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Perks
              const Text(
                "Perks Included",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B060A),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _perkItem("assets/cctv_icon.png", "CCTV"),
                  const SizedBox(width: 12),
                  _perkItem("assets/caretaker_icon.png", "Caretaker"),
                  const SizedBox(width: 12),
                  _perkItem("assets/insurance_icon.png", "Insurance"),
                  const SizedBox(width: 12),
                  _perkItem("assets/carwash_icon.png", "Carwash"),
                ],
              ),

              const SizedBox(height: 20),

              // Payment Options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: SizedBox(
                          width: 60, // force same width
                          height: 40, // force same height
                          child: Image.asset(
                            "assets/gcash_icon.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: SizedBox(
                          width: 60, // same width
                          height: 40, // same height
                          child: Image.asset(
                            "assets/paymaya_icon.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Increased height
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(
                    18,
                  ), // Increased padding for more height
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      // Icon positioned at the left
                      // Icon positioned at the left
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Image.asset(
                          "assets/bank_icon.png",
                          height:
                              35, // Set the height to match the previous icon size
                          width: 35, // Set width to maintain aspect ratio
                        ),
                      ),
                      // Centered text
                      Center(
                        child: Text(
                          "Bank Transfer",
                          style: TextStyle(
                            fontSize: 18, // Slightly increased font size
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3B060A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Input Fields
              TextField(
                decoration: InputDecoration(
                  hintText: "Number",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Color(0xFF3B060A)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: "Account Name",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: const BorderSide(color: Color(0xFF3B060A)),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Confirm Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF02542D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConfirmationPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      color: Color(0xFFFDF7D8),
                      fontWeight: FontWeight.bold, // Made text bold
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Total Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Total Amount:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF3B060A),
                    ),
                  ),
                  Text(
                    "PHP 2500.00",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF3B060A),
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

  // Perk Item Builder
  Widget _perkItem(String assetPath, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF3B060A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(assetPath, height: 24, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF3B060A)),
        ),
      ],
    );
  }
}
