import 'package:flutter/material.dart';
import 'package:parkditto/pages/booking_contents/payment.dart';

class StormPassPage extends StatelessWidget {
  const StormPassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1E8), // Cream background
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
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
                      "Storm Pass",
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

            const SizedBox(height: 30),

            // Parkditto Logo
            Image.asset(
              "assets/parkditto_icon.png",
              height: 120, // Adjust size as needed
              width: 120,
            ),

            const SizedBox(height: 40),

            // Price section
            Container(
              width: double.infinity, // Make it take full width
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3C6),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align "For only" to the left
                children: [
                  const Text(
                    'For only',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3B060A),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        '799 pesos',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B060A),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight, // Push Monthly to right
                    child: const Text(
                      'Monthly',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B060A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Perks section
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ), // Add left and right margin
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Perks',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(
                          0xFF3B060A,
                        ), // Changed to your specified color
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Perks list
                  _buildPerkItem('Unlimited parking during storms'),
                  const SizedBox(height: 12),
                  _buildPerkItem('Covered/Indoor Parking Upgrade'),
                  const SizedBox(height: 12),
                  _buildPerkItem('Priority Spot Reservation'),
                  const SizedBox(height: 12),
                  _buildPerkItem('Storm alerts'),
                ],
              ),
            ),

            const Spacer(),

            // Avail Now button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 45),
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => const PaymentPage(
                        planName: "Monthly",
                        planPrice: "799/m",
                        planColor: Color(0xFFFDF7D8),
                        textColor: Colors.black,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B060A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Avail Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPerkItem(String text) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Space between text and icon
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF3B060A), // Changed to your specified color
            ),
          ),
        ),
        const SizedBox(width: 12),
        Image.asset(
          "assets/checkMark_icon.png",
          height: 24, // Adjust size as needed
          width: 24,
        ),
      ],
    );
  }
}

// Custom painter for the ripple effect
class RipplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw concentric circles for ripple effect
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 60, height: 15),
      paint,
    );

    canvas.drawOval(
      Rect.fromCenter(center: center, width: 80, height: 20),
      paint..color = Colors.black.withOpacity(0.2),
    );

    canvas.drawOval(
      Rect.fromCenter(center: center, width: 100, height: 25),
      paint..color = Colors.black.withOpacity(0.1),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
