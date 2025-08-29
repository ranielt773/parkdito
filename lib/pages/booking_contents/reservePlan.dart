import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'stormPass.dart';
import 'payment.dart';



class ReservePlanPage extends StatefulWidget {
  final Map<String, dynamic> parkingData;
  final int selectedSlot;
  final String selectedFloor;
  final String selectedVehicle;
  const ReservePlanPage({
    super.key,
    required this.parkingData,
    required this.selectedSlot,
    required this.selectedFloor,
    required this.selectedVehicle,
  });

  @override
  State<ReservePlanPage> createState() => _ReservePlanPageState();
}

class _ReservePlanPageState extends State<ReservePlanPage> {
  // State variables for date & time
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        "Choose your Plan",
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



              const SizedBox(height: 20),

              // Weekly
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        planName: "Yearly",
                        planPrice: "30000/yr",
                        planColor: Color(0xFF3B060A),
                        textColor: Colors.white,
                        parkingData: widget.parkingData, // Add this
                        selectedSlot: widget.selectedSlot, // Add this
                        selectedFloor: widget.selectedFloor, // Add this
                        selectedVehicle: widget.selectedVehicle, // Add this
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  margin: const EdgeInsets.only(
                    bottom: 12,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFDF2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Weekly", style: TextStyle(fontSize: 16)),
                      Text(
                        "750/wk",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              // Monthly
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        planName: "Yearly",
                        planPrice: "30000/yr",
                        planColor: Color(0xFF3B060A),
                        textColor: Colors.white,
                        parkingData: widget.parkingData, // Add this
                        selectedSlot: widget.selectedSlot, // Add this
                        selectedFloor: widget.selectedFloor, // Add this
                        selectedVehicle: widget.selectedVehicle, // Add this
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  margin: const EdgeInsets.only(
                    bottom: 12,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xCC3B060A),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Monthly",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        "2500/m",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Yearly
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        planName: "Yearly",
                        planPrice: "30000/yr",
                        planColor: Color(0xFF3B060A),
                        textColor: Colors.white,
                        parkingData: widget.parkingData, // Add this
                        selectedSlot: widget.selectedSlot, // Add this
                        selectedFloor: widget.selectedFloor, // Add this
                        selectedVehicle: widget.selectedVehicle, // Add this
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xCC3B060A),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Yearly",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        "30000/yr",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // After Yearly, before Perks Included
              const Text(
                "Select time of arrival",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B060A),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  // Date Picker
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // left align
                      children: [
                        const Text(
                          "Date",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3B060A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedDate = picked;
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                              vertical: 9,
                              horizontal: 17,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF7D8),
                              border: Border.all(color: Color(0xFF3B060A)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat("E, MMM d").format(_selectedDate),
                                  style: const TextStyle(
                                    color: Color(0xFF3B060A),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFF3B060A),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Time Picker
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // left align
                      children: [
                        const Text(
                          "Time",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3B060A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (picked != null) {
                              setState(() {
                                _selectedTime = picked;
                              });
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                              vertical: 9,
                              horizontal: 17,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF7D8),
                              border: Border.all(color: Color(0xFF3B060A)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedTime.format(context),
                                  style: const TextStyle(
                                    color: Color(0xFF3B060A),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFF3B060A),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Perks Included
              const Text(
                "Perks Included",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B060A),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _perkItem("assets/cctv_icon.png", "CCTV"),
                  const SizedBox(width: 16),
                  _perkItem("assets/caretaker_icon.png", "Caretaker"),
                  const SizedBox(width: 16),
                  _perkItem("assets/insurance_icon.png", "Insurance"),
                  const SizedBox(width: 16),
                  _perkItem("assets/carwash_icon.png", "Carwash"),
                ],
              ),
              const SizedBox(height: 24),

              // Purchase Storm Pass
              Container(
                height: 150, // Set a fixed height to fill the space
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3C6),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    // Title at the top
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: const Text(
                          "Purchase Storm Pass",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B060A),
                          ),
                        ),
                      ),
                    ),
                    // Centered storm icon
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Image.asset("assets/storm_icon.png", height: 50),
                      ),
                    ),
                    // Button positioned at bottom right
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StormPassPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3B060A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 7,
                          ),
                        ),
                        child: const Text("Avail Now"),
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

  // Perks Widget
  Widget _perkItem(String iconPath, String title) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF3B060A),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Image.asset(
            iconPath,
            height: 28,
            width: 28,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF3B060A),
          ),
        ),
      ],
    );
  }
}
